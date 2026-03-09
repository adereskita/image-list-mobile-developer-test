//
//  ImageRepository.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation
import Moya

final class ImageRepository: ImageRepositoryProtocol {
    private let provider: MoyaProvider<ImageAPI>

    init(provider: MoyaProvider<ImageAPI> = MoyaProvider<ImageAPI>()) {
        self.provider = provider
    }

    func fetchImages(page: Int, limit: Int) async throws -> [ImageItem] {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getImages(page: page, limit: limit)) { result in
                switch result {
                case .success(let response):
                    do {
                        let dtos = try JSONDecoder().decode([ImageDTO].self, from: response.data)
                        let domainItems = dtos.map { $0.toDomain() }
                        continuation.resume(returning: domainItems)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
