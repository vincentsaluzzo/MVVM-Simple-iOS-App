//
//  CommentsViewModeling.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentsViewModeling {
    var loading: BehaviorSubject<Bool> { get }
    var comments: BehaviorSubject<[CommentViewModeling]> { get }

    func postComment(body: String) -> Observable<Void>
    func reloadComments()
}
