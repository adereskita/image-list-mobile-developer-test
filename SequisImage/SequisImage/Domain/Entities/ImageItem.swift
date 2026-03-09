//
//  ImageItem.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

struct ImageItem: Identifiable, Equatable {
    let id: String
    let author: String
    let url: URL?
    let downloadUrl: URL?
}
