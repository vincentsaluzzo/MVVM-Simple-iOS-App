//
//  CommentsViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

class CommentsViewModel: CommentsViewModeling {
    var loading: BehaviorSubject<Bool>
    var comments: BehaviorSubject<[CommentViewModeling]>

    let disposeBag = DisposeBag()
    let provider = MoyaProvider<PostAPI>()
    let post: Post
    let user: User
    init(_ post: Post, _ user: User) {
        self.post = post
        self.user = user
        loading = BehaviorSubject(value: true)
        comments = BehaviorSubject(value: [])

        provider.rx.request(.getComments(post.id))
            .filterSuccessfulStatusCodes()
            .map([Comment].self)
            .debug("getComments(\(post.id))", trimOutput: false)
            .do(onDispose: { [weak self] in
                self?.loading.onNext(false)
            })
            .subscribe(onSuccess: { [weak self] (comments) in
                self?.comments.onNext(comments.map { CommentViewModel($0) })
            })
            .disposed(by: disposeBag)
    }

    func postComment(body: String) -> Observable<Void> {
        let comment = Comment(postId: post.id,
                              id: nil,
                              name: self.user.name,
                              email: self.user.email,
                              body: body)

        return provider.rx.request(.createComment(comment))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .debug("createComment", trimOutput: false)
            .map { _ in return }
    }

    func reloadComments() {
        loading.onNext(true)
        provider.rx.request(.getComments(post.id))
            .filterSuccessfulStatusCodes()
            .map([Comment].self)
            .debug("getComments(\(post.id))", trimOutput: false)
            .do(onDispose: { [weak self] in
                self?.loading.onNext(false)
            })
            .subscribe(onSuccess: { [weak self] (comments) in
                self?.comments.onNext(comments.map { CommentViewModel($0) })
            })
            .disposed(by: disposeBag)
    }
}
