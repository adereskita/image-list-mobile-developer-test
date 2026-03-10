import Combine
import XCTest

@testable import SequisImage

@MainActor
final class ImageListViewModelTests: XCTestCase {
    var sut: ImageListViewModel?
    var mockUseCase: MockGetImagesUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() async throws {
        try await super.setUp()
        mockUseCase = MockGetImagesUseCase()
        sut = ImageListViewModel(getImagesUseCase: mockUseCase)
        cancellables = []
    }

    override func tearDown() async throws {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        try await super.tearDown()
    }

    func testFetchImages_Success_PopulatesImagesAndIncrementsPage() throws {
        // Arrange
        let expectedImages = [
            ImageItem(
                id: "1", author: "Author 1", url: URL(string: "https://picsum.photos/seed/picsum/200/300"),
                downloadUrl: nil),
            ImageItem(
                id: "2", author: "Author 2", url: URL(string: "https://picsum.photos/seed/picsum/200/300"),
                downloadUrl: nil),
        ]
        mockUseCase.resultToBeReturned = .success(expectedImages)

        let expectation = XCTestExpectation(description: "Fetch completes")
        var isLoadingValues = [Bool]()

        sut?.$isLoading
            .dropFirst()
            .sink { isLoading in
                isLoadingValues.append(isLoading)
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        sut?.fetchImages()

        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(isLoadingValues, [true, false])
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(mockUseCase.lastPageRequested, 1)
        XCTAssertEqual(sut?.images.count, 2)
        XCTAssertEqual(sut?.images, expectedImages)
        XCTAssertNil(sut?.errorMessage)
    }

    func testFetchImages_Failure_SetsErrorMessage() throws {
        // Arrange
        let expectedError = NSError(
            domain: "Test", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockUseCase.resultToBeReturned = .failure(expectedError)

        let expectation = XCTestExpectation(description: "Fetch completes with error")
        var isLoadingValues = [Bool]()

        sut?.$isLoading
            .dropFirst()
            .sink { isLoading in
                isLoadingValues.append(isLoading)
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        sut?.fetchImages()

        guard let sut else { return XCTFail("SUT is nil")}
        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(isLoadingValues, [true, false])
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertTrue(sut.images.isEmpty)
        XCTAssertEqual(sut.errorMessage, expectedError.localizedDescription)
    }

    func testFetchImages_Pagination_AppendsNewImages() throws {
        // Arrange
        let initialImages = [ImageItem(id: "1", author: "Author 1", url: nil, downloadUrl: nil)]

        mockUseCase.resultToBeReturned = .success(initialImages)

        let firstFetchExpectation = XCTestExpectation(description: "First fetch completes")
        sut?.$isLoading
            .dropFirst()
            .filter { !$0 }  // wait for false
            .first()
            .sink { _ in firstFetchExpectation.fulfill() }
            .store(in: &cancellables)

        sut?.fetchImages()
        wait(for: [firstFetchExpectation], timeout: 2.0)
        XCTAssertEqual(sut?.images.count, 1)
        XCTAssertEqual(mockUseCase.lastPageRequested, 1)

        let newImages = [ImageItem(id: "2", author: "Author 2", url: nil, downloadUrl: nil)]
        mockUseCase.resultToBeReturned = .success(newImages)

        let secondFetchExpectation = XCTestExpectation(description: "Second fetch completes")
        sut?.$isLoading
            .dropFirst()  // from this subscription
            .filter { !$0 }  // wait for false
            .first()
            .sink { _ in secondFetchExpectation.fulfill() }
            .store(in: &cancellables)

        // Act
        sut?.fetchImages()
        wait(for: [secondFetchExpectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(mockUseCase.executeCallCount, 2)
        XCTAssertEqual(mockUseCase.lastPageRequested, 2)
        XCTAssertEqual(sut?.images.count, 2)
        XCTAssertEqual(sut?.images[1], newImages[0])
    }

    func testFetchImages_EmptyResult_SetsIsLastPage() throws {
        // Arrange
        mockUseCase.resultToBeReturned = .success([])

        let expectation = XCTestExpectation(description: "Fetch completes with empty results")
        sut?.$isLoading
            .dropFirst()
            .filter { !$0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        // Act
        sut?.fetchImages()

        guard let sut else { return XCTFail("SUT is nil")}

        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertTrue(sut.images.isEmpty)

        // Subsequent calls should not execute the use case again
        sut.fetchImages()
        XCTAssertEqual(mockUseCase.executeCallCount, 1)  // Call count remains 1
    }
}
