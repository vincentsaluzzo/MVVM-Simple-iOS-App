//
//  UserAPI.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxMoya
import Moya

enum UserAPI {
    case getUsers
    case getUser(Int)
    case getPosts(Int)
    case getAlbums(Int)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return JSONAPI.baseUrl
    }

    var path: String {
        switch self {
        case .getUsers: return "/users"
        case .getUser(let userId): return "/users/\(userId)"
        case .getPosts(let userId): return "/users/\(userId)/posts"
        case .getAlbums(let userId): return "/users/\(userId)/albums"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUser, .getUsers, .getPosts, .getAlbums: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getUser, .getUsers, .getPosts, .getAlbums: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }

}
