//
//  CommentViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CommentViewModel: CommentViewModeling {
    var from: String
    var body: String

    init(_ comment: Comment) {
        from = comment.email
        body = comment.body ?? ""
    }

}
