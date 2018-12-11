//
//  UserViewModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class UserViewModelTests: XCTestCase {

    var viewModel: UserViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UserViewModel(User(id: 1, name: "Vincent", username: "vincent", email: "vs@gmail.com", address: nil, phone: nil, website: nil, company: nil))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelPresentationIsOk() {
        XCTAssert(viewModel.email == "vs@gmail.com", "email isn't good in presentation view model")
        XCTAssert(viewModel.name == "Vincent", "username isn't good in presentation view model")
        XCTAssert(viewModel.profileImage.isEmpty == false, "image profile isn't present in presentation view model")
    }

    func testLoadingUserPosts() {
        viewModel.loadNextPosts()

        do {
            let posts = try viewModel.posts.skip(1).toBlocking(timeout: 5).first()!
            XCTAssert(posts.isEmpty == false, "User post is empty")
        } catch {
            XCTFail("View model fail to retrieve user posts list \(error)")
        }

    }
}
