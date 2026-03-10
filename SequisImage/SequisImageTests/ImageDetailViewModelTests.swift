import Foundation
import XCTest

@testable import SequisImage

@MainActor
final class ImageDetailViewModelTests: XCTestCase {
    var sut: ImageDetailViewModel?
    var mockRepository: MockCommentLocalRepository!
    var generator: CommentGenerator!
    var testImageItem: ImageItem!

    override func setUp() async throws {
        try await super.setUp()
        testImageItem = ImageItem(
            id: "test-id",
            author: "Test Author",
            url: URL(string: "https://picsum.photos/seed/picsum/200/300"),
            downloadUrl: nil
        )
        mockRepository = MockCommentLocalRepository()
        generator = CommentGenerator()
    }

    override func tearDown() async throws {
        sut = nil
        mockRepository = nil
        generator = nil
        testImageItem = nil
        try await super.tearDown()
    }

    func testInit_LoadsCommentsFromRepository() {
        // Arrange
        let expectedComments = [
            CommentItem(
                id: UUID(), imageId: "test-id", authorInitials: "AB", authorName: "A B",
                text: "Comment 1", createdAt: Date()),
            CommentItem(
                id: UUID(), imageId: "test-id", authorInitials: "CD", authorName: "C D",
                text: "Comment 2", createdAt: Date()),
        ]
        mockRepository.commentsResultToBeReturned = expectedComments

        // Act
        sut = ImageDetailViewModel(
            imageItem: testImageItem,
            repository: mockRepository,
            generator: generator
        )
        
        guard let sut else { return XCTFail("SUT is nil") }
        
        // Assert
        XCTAssertEqual(mockRepository.getCommentsCallCount, 1)
        XCTAssertEqual(mockRepository.lastImageIdRequested, testImageItem.id)
        XCTAssertEqual(sut.comments.count, 2)
        XCTAssertEqual(sut.comments, expectedComments)
    }

    func testAddComment_GeneratesCommentSavesAndAppendsToTop() {
        // Arrange
        sut = ImageDetailViewModel(
            imageItem: testImageItem,
            repository: mockRepository,
            generator: generator
        )
        guard let sut else { return XCTFail("SUT is nil") }
        
        XCTAssertTrue(sut.comments.isEmpty)

        // Act
        sut.addComment()

        // Assert
        XCTAssertEqual(mockRepository.saveCallCount, 1)
        XCTAssertNotNil(mockRepository.lastSavedComment)

        let savedComment = mockRepository.lastSavedComment!
        XCTAssertEqual(savedComment.imageId, testImageItem.id)
        
        XCTAssertEqual(sut.comments.count, 1)
        XCTAssertEqual(sut.comments.first, savedComment)

        // Add another comment to verify it's added to the top (index 0)
        sut.addComment()
        XCTAssertEqual(sut.comments.count, 2)
        XCTAssertEqual(sut.comments.first, mockRepository.lastSavedComment)
    }

    func testDeleteComment_RemovesFromRepositoryAndArray() {
        // Arrange
        let comment1 = CommentItem(
            id: UUID(), imageId: "test-id", authorInitials: "AB", authorName: "A B",
            text: "Comment 1", createdAt: Date())
        let comment2 = CommentItem(
            id: UUID(), imageId: "test-id", authorInitials: "CD", authorName: "C D",
            text: "Comment 2", createdAt: Date())
        let comment3 = CommentItem(
            id: UUID(), imageId: "test-id", authorInitials: "EF", authorName: "E F",
            text: "Comment 3", createdAt: Date())

        mockRepository.commentsResultToBeReturned = [comment1, comment2, comment3]

        sut = ImageDetailViewModel(
            imageItem: testImageItem,
            repository: mockRepository,
            generator: generator
        )
        guard let sut else { return XCTFail("SUT is nil") }
        
        XCTAssertEqual(sut.comments.count, 3)

        // Act - Delete comment at index 1 (comment2)
        let indexSet = IndexSet(integer: 1)
        sut.deleteComment(at: indexSet)

        // Assert
        XCTAssertEqual(mockRepository.deleteCallCount, 1)
        XCTAssertEqual(mockRepository.lastDeletedCommentId, comment2.id)
        XCTAssertEqual(mockRepository.lastImageIdRequested, testImageItem.id)

        XCTAssertEqual(sut.comments.count, 2)
        XCTAssertEqual(sut.comments[0], comment1)
        XCTAssertEqual(sut.comments[1], comment3)
    }
}
