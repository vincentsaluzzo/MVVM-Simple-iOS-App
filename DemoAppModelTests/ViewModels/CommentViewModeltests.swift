//
//  CommentViewModeltests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class CommentViewModeltests: XCTestCase {

    var viewModel: CommentViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CommentViewModel(Comment(postId: 1, id: 1, name: "Vincent", email: "vs@gmail.com", body: "A body message"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelPresentationIsOk() {
        XCTAssert(viewModel.from == "vs@gmail.com", "email user from isn't good in presentation view model")
        XCTAssertNotNil(viewModel.body, "Body presentation property is nil")
        XCTAssert(viewModel.body == "A body message", "Body message isn't good in presentation view model")
    }

    func testViewModelWithEmptyBody() {
        viewModel = CommentViewModel(Comment(postId: 1, id: 1, name: "Vincent", email: "vs@gmail.com", body: nil))
        XCTAssert(viewModel.body == "", "Nil body message wasn't correctly transformed as empty string")
    }
}
