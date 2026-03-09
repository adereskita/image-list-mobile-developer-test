//
//  ImageAPI.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation
import Moya

enum ImageAPI {
    case getImages(page: Int, limit: Int)
}

extension ImageAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://picsum.photos/v2")!
    }

    var path: String {
        switch self {
        case .getImages:
            return "/list"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .getImages(let page, let limit):
            return .requestParameters(
                parameters: ["page": page, "limit": limit], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
