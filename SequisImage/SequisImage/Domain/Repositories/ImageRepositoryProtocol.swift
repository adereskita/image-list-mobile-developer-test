//
//  ImageRepositoryProtocol.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

protocol ImageRepositoryProtocol {
    func fetchImages(page: Int, limit: Int) async throws -> [ImageItem]
}
