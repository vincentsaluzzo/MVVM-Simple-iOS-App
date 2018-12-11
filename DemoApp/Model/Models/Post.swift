//
//  Post.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
