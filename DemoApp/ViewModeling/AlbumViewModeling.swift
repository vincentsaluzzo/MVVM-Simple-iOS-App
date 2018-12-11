//
//  AlbumViewModeling.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift

protocol AlbumViewModeling {
    var loading: BehaviorSubject<Bool> { get }
    var photos: BehaviorSubject<[PhotoViewModeling]> { get }
    var title: String { get }
}
