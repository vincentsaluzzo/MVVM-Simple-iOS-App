//
//  PhotoViewModeling.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol PhotoViewModeling {
    var thumbnail: String { get }
    var url: String { get }
    var title: String { get }
}
