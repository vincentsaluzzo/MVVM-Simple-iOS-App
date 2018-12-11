//
//  CommentsViewModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class CommentsViewModelTests: XCTestCase {

    var viewModel: CommentsViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CommentsViewModel(
            Post(userId: 1, id: 1, title: "Article post", body: "body"),
            User(id: 1, name: "Vincent", username: "vincent", email: "vs@gmail.com", address: nil, phone: nil, website: nil, company: nil)
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCommentListInitialized() {

        do {
            _ = try viewModel.loading.asObservable()
                .skip(1)
                .toBlocking(timeout: 5)
                .first()!

        } catch {
            XCTFail("Failing to finish loading view model \(error)")
        }
        do {
            let comments = try viewModel.comments.asObservable()
                .toBlocking(timeout: 1)
                .first()!

            XCTAssert(comments.isEmpty == false, "Comment list is empty in view model")
        } catch {
            XCTFail("View model fail to initialise user list \(error)")
        }
    }

    func testPostComment() {
        do {
            try viewModel.postComment(body: "New comment")
            .toBlocking(timeout: 5)
            .single()
        } catch {
            XCTFail("Can't post a new comment")
        }
    }
}
