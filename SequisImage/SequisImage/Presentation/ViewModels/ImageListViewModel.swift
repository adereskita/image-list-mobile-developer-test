//
//  ImageListViewModel.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Combine
import Foundation

@MainActor
final class ImageListViewModel: ObservableObject {
    @Published var images: [ImageItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let getImagesUseCase: GetImagesUseCaseProtocol
    private var currentPage = 1
    private let limit = 15
    private var isLastPage = false

    init(getImagesUseCase: GetImagesUseCaseProtocol) {
        self.getImagesUseCase = getImagesUseCase
    }

    func fetchImages() {
        guard !isLoading && !isLastPage else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedImages = try await getImagesUseCase.execute(
                    page: currentPage, limit: limit)
                if fetchedImages.isEmpty {
                    isLastPage = true
                } else {
                    self.images.append(contentsOf: fetchedImages)
                    self.currentPage += 1
                }
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
