//
//  Comment.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var postId: Int
    var id: Int?
    var name: String
    var email: String
    var body: String?

}
