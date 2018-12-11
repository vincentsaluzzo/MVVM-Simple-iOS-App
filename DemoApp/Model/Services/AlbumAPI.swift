//
//  AlbumAPI.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxMoya
import Moya

enum AlbumAPI {
    case getPhotos(Int)
}

extension AlbumAPI: TargetType {
    var baseURL: URL {
        return JSONAPI.baseUrl
    }

    var path: String {
        switch self {
        case .getPhotos(let albumId): return "/albums/\(albumId)/photos"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPhotos: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getPhotos: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }

}
