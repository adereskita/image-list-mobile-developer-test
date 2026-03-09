//
//  GetImagesUseCase.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

protocol GetImagesUseCaseProtocol {
    func execute(page: Int, limit: Int) async throws -> [ImageItem]
}

final class GetImagesUseCase: GetImagesUseCaseProtocol {
    private let repository: ImageRepositoryProtocol

    init(repository: ImageRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, limit: Int) async throws -> [ImageItem] {
        return try await repository.fetchImages(page: page, limit: limit)
    }
}
