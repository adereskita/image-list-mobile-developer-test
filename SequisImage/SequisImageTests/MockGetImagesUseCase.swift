import Foundation

@testable import SequisImage

final class MockGetImagesUseCase: GetImagesUseCaseProtocol {
    var resultToBeReturned: Result<[ImageItem], Error> = .success([])
    var executeCallCount = 0
    var lastPageRequested: Int?
    var lastLimitRequested: Int?

    func execute(page: Int, limit: Int) async throws -> [ImageItem] {
        executeCallCount += 1
        lastPageRequested = page
        lastLimitRequested = limit

        switch resultToBeReturned {
        case .success(let items):
            return items
        case .failure(let error):
            throw error
        }
    }
}
