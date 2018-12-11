//
//  PostViewModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class PostViewModelTests: XCTestCase {

    var viewModel: PostViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = PostViewModel(
            Post(userId: 1, id: 1, title: "Article post", body: "body"),
            User(id: 1, name: "Vincent", username: "vincent", email: "vs@gmail.com", address: nil, phone: nil, website: nil, company: nil)
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelPresentationIsOk() {
        XCTAssert(viewModel.body == "body", "body isn't good in presentation view model")
        XCTAssert(viewModel.title == "Article post", "title isn't good in presentation view model")
    }

    func testLoadingCommentsNumber() {
        do {
            let commentNumber = viewModel.commentNumber.skip(1).toBlocking(timeout: 5)
            XCTAssertNotNil(try commentNumber.first()!, "Failed to retrieve comment numbers")
        } catch {
            XCTFail("View model fail to retrieve comment number \(error)")
        }

    }
}
