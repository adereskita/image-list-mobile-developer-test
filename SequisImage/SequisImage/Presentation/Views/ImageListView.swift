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

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.images) { item in
                    ImageRowView(item: item)
                        .onAppear {
                            if item == viewModel.images.last {
                                viewModel.fetchImages()
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGroupedBackground))
                }

                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
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
        }
    }
}

struct ImageRowView: View {
    let item: ImageItem

    var body: some View {
        HStack(spacing: 0) {
            KFImage(item.downloadUrl)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .frame(width: 100, height: 100)

            VStack {
                Text("Author:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(item.author)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
