import Foundation

@testable import SequisImage

final class MockCommentLocalRepository: CommentLocalRepositoryProtocol {
    var commentsResultToBeReturned: [CommentItem] = []

    var getCommentsCallCount = 0
    var saveCallCount = 0
    var deleteCallCount = 0

    var lastSavedComment: CommentItem?
    var lastDeletedCommentId: UUID?
    var lastImageIdRequested: String?

    func getComments(forImageId imageId: String) -> [CommentItem] {
        getCommentsCallCount += 1
        lastImageIdRequested = imageId
        return commentsResultToBeReturned
    }

    func save(comment: CommentItem) {
        saveCallCount += 1
        lastSavedComment = comment
    }

    func delete(commentId: UUID, forImageId imageId: String) {
        deleteCallCount += 1
        lastDeletedCommentId = commentId
        lastImageIdRequested = imageId
    }
}
