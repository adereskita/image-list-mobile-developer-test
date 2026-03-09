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

    // Dependencies
    private lazy var imageRepository = ImageRepository()
    lazy var getImagesUseCase = GetImagesUseCase(repository: imageRepository)

    func navigate(to route: AppRoute) {
        currentRoute = route
    }
}
