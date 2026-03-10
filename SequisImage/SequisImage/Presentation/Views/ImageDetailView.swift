//
//  ImageDetailView.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Kingfisher
import SwiftUI

struct ImageDetailView: View {
    @StateObject var viewModel: ImageDetailViewModel

    var body: some View {
        VStack(spacing: 0) {
            KFImage(viewModel.imageItem.downloadUrl)
                .downsampling(size: CGSize(width: 800, height: 600))
                .cacheOriginalImage()
                .placeholder {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 300)
                .clipped()

            List {
                ForEach(viewModel.comments) { comment in
                    CommentRowView(comment: comment)
                        .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                .onDelete { indexSet in
                    viewModel.deleteComment(at: indexSet)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Image Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        viewModel.addComment()
                    }
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct CommentRowView: View {
    let comment: CommentItem

    private var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: comment.createdAt, relativeTo: Date())
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 40, height: 40)

                Text(comment.authorInitials)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(comment.authorName)
                    .font(.headline)
                    .fontWeight(.bold)

                Text(comment.text)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(nil)

                Text(timeAgoString)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
