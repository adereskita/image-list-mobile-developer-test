//
//  CommentLocalRepositoryProtocol.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

protocol CommentLocalRepositoryProtocol {
    func getComments(forImageId imageId: String) -> [CommentItem]
    func save(comment: CommentItem)
    func delete(commentId: UUID, forImageId imageId: String)
}
