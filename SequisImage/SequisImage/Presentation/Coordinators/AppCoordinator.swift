//
//  AppCoordinator.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import SwiftUI

enum AppRoute: Hashable {
    case splash
    case imageList
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    @Published var selectedImageItem: ImageItem?

    // Dependencies
    private lazy var imageRepository = ImageRepository()
    lazy var getImagesUseCase = GetImagesUseCase(repository: imageRepository)

    func navigate(to route: AppRoute) {
        currentRoute = route
    }

    func showDetail(for item: ImageItem) {
        selectedImageItem = item
    }

    func imageDetailViewModel(for item: ImageItem) -> ImageDetailViewModel {
        return ImageDetailViewModel(imageItem: item)
    }
}
