//
//  CommentItem.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

struct CommentItem: Identifiable, Equatable, Codable {
    let id: UUID
    let imageId: String
    let authorInitials: String
    let authorName: String
    let text: String
    let createdAt: Date
}
