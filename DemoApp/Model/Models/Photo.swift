//
//  Photo.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}
