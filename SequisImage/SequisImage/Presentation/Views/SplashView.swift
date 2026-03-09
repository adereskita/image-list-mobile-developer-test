//
//  SplashView.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Text("Sequis Image App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .onAppear {
            viewModel.onSplashFinished = onFinished
            viewModel.startSplash()
        }
    }
}
