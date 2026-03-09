//
//  ImageDTO.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

struct ImageDTO: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String

    func toDomain() -> ImageItem {
        return ImageItem(
            id: id,
            author: author,
            url: URL(string: url),
            downloadUrl: URL(string: download_url)
        )
    }
}
