//
//  ImageListView.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Kingfisher
import SwiftUI

struct ImageListView: View {
    @StateObject var viewModel: ImageListViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.images) { item in
                    Button(action: {
                        coordinator.showDetail(for: item)
                    }) {
                        ImageRowView(item: item)
                            .onAppear {
                                if item == viewModel.images.last {
                                    viewModel.fetchImages()
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(.systemGroupedBackground))
                }

                if viewModel.isLoading {
                    ImageRowView(item: nil, isLoading: true)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGroupedBackground))
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Image List")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.images.isEmpty {
                    viewModel.fetchImages()
                }
            }
            .background(
                NavigationLink(
                    isActive: Binding(
                        get: { coordinator.selectedImageItem != nil },
                        set: { if !$0 { coordinator.selectedImageItem = nil } }
                    ),
                    destination: {
                        if let item = coordinator.selectedImageItem {
                            ImageDetailView(viewModel: coordinator.imageDetailViewModel(for: item))
                        } else {
                            EmptyView()
                        }
                    },
                    label: { EmptyView() }
                )
            )
        }
    }
}

struct ImageRowView: View {
    let item: ImageItem?
    var isLoading: Bool = false
    @State private var isBlinking = false

    var body: some View {
        HStack(spacing: 0) {
            if isLoading {
                Color.gray.opacity(0.3)
                    .frame(width: 100, height: 100)
            } else if let item = item {
                KFImage(item.downloadUrl)
                    .downsampling(size: CGSize(width: 200, height: 200))
                    .cacheOriginalImage()
                    .placeholder {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .frame(width: 100, height: 100)
            }

            VStack(spacing: isLoading ? 8 : 0) {
                if isLoading {
                    Color.gray.opacity(0.3)
                        .frame(width: 80, height: 20)
                        .cornerRadius(4)
                    Color.gray.opacity(0.3)
                        .frame(width: 120, height: 16)
                        .cornerRadius(4)
                } else if let item = item {
                    Text("Author:")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(item.author)
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .opacity(isLoading && isBlinking ? 0.3 : 1.0)
        .onAppear {
            if isLoading {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isBlinking = true
                }
            }
        }
    }
}

//#Preview {
//    ImageListView(
//        viewModel: ImageListViewModel(
//            getImagesUseCase: GetImagesUseCase(
//                repository: ImageRepository()
//            )
//        )
//    )
//}
