//
//  UserViewModeling.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift

protocol UserViewModeling {
    var profileImage: String { get }
    var name: String { get }
    var email: String { get }

    var posts: BehaviorSubject<[PostViewModeling]> { get }
    func loadNextPosts()

    var albumsViewModel: AlbumsViewModeling { get }
}
