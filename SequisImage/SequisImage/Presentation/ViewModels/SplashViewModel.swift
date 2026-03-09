//
//  SplashViewModel.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    var onSplashFinished: (() -> Void)?

    func startSplash() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)  // 2 seconds
            onSplashFinished?()
        }
    }
}
