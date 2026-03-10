//
//  ImageDetailViewModel.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Combine
import Foundation

@MainActor
final class ImageDetailViewModel: ObservableObject {
    @Published var comments: [CommentItem] = []
    let imageItem: ImageItem

    private let repository: CommentLocalRepositoryProtocol
    private let generator: CommentGenerator

    init(
        imageItem: ImageItem,
        repository: CommentLocalRepositoryProtocol = CommentLocalRepository(),
        generator: CommentGenerator = CommentGenerator()
    ) {
        self.imageItem = imageItem
        self.repository = repository
        self.generator = generator
        loadComments()
    }

    private func loadComments() {
        comments = repository.getComments(forImageId: imageItem.id)
    }

    func addComment() {
        let newComment = generator.generateComment(forImageId: imageItem.id)
        repository.save(comment: newComment)
        comments.insert(newComment, at: 0)
    }

    func deleteComment(at offsets: IndexSet) {
        for index in offsets {
            let comment = comments[index]
            repository.delete(commentId: comment.id, forImageId: imageItem.id)
        }
        comments.remove(atOffsets: offsets)
    }
}
