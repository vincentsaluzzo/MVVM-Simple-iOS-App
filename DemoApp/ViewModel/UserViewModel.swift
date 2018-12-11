//
//  UserViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

class UserViewModel: UserViewModeling {
    var profileImage: String
    var name: String
    var email: String
    var posts: BehaviorSubject<[PostViewModeling]>

    let provider = MoyaProvider<UserAPI>()
    let disposeBag = DisposeBag()
    private let user: User
    init(_ user: User) {
        self.user = user
        let imageText = user.name
            .split(separator: " ")
            .map({ String($0.first!).uppercased()})
            .joined()
        self.profileImage = "https://via.placeholder.com/300/000000/AA3333/?text=\(imageText)"
        self.name = user.name
        self.email = user.email
        self.posts = BehaviorSubject(value: [])
    }

    func loadNextPosts() {
        provider.rx.request(.getPosts(user.id))
            .filterSuccessfulStatusCodes()
            .map([Post].self)
            .debug("getUserPost(\(user.id))", trimOutput: false)
            .subscribe({ [weak self] (element) in
                guard let self = self else { return }
                guard case .success(let posts) = element else { return }
                let oldPosts = (try? self.posts.value()) ?? []
                self.posts.onNext(oldPosts + posts.map { PostViewModel($0, self.user) })
            })
            .disposed(by: disposeBag)
    }

    var albumsViewModel: AlbumsViewModeling {
        return AlbumsViewModel(user)
    }
}
