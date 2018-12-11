//
//  PostViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class PostViewModel: PostViewModeling {
    var title: String
    var body: String
    var commentNumber: BehaviorSubject<Int?>

    let disposeBag = DisposeBag()
    let provider = MoyaProvider<PostAPI>()
    let userProvider = MoyaProvider<UserAPI>()
    let user: User
    let post: Post
    init(_ post: Post, _ user: User) {
        self.post = post
        self.user = user
        title = post.title
        body = post.body
        commentNumber = BehaviorSubject(value: nil)

        provider.rx.request(.getComments(post.id))
            .filterSuccessfulStatusCodes()
            .map([Comment].self)
            .debug("getComments(\(post.id))", trimOutput: false)
            .subscribe(onSuccess: { [weak self] (comments) in
                self?.commentNumber.onNext(comments.count)
            })
            .disposed(by: disposeBag)
    }

    var commentViewModel: CommentsViewModeling {
        return CommentsViewModel(post, user)
    }

}
