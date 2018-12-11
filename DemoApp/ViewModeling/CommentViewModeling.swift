//
//  CommentViewModeling.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentViewModeling {
    var from: String { get }
    var body: String { get }
}
