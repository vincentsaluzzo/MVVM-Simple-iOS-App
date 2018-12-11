//
//  PostAPI.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxMoya
import Moya

enum PostAPI {
    case getComments(Int)
    case createComment(Comment)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return JSONAPI.baseUrl
    }

    var path: String {
        switch self {
        case .getComments(let postId): return "/posts/\(postId)/comments"
        case .createComment: return "/comments"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getComments: return .get
        case .createComment: return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getComments: return .requestPlain
        case .createComment(let comment): return .requestJSONEncodable(comment)
        }
    }

    var headers: [String: String]? {
        return nil
    }

}
