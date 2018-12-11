//
//  UsersViewModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class UsersViewModelTests: XCTestCase {

    var viewModel: UsersViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UsersViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsersList() {

        do {
            _ = try viewModel.isLoading.asObservable()
                .skip(1)
                .toBlocking(timeout: 5)
                .first()!

        } catch {
            XCTFail("Failing to finish loading view model \(error)")
        }
        do {
            let users = try viewModel.users.asObservable()
                .toBlocking(timeout: 1)
                .first()!

            XCTAssert(users.isEmpty == false, "Users list is empty in view model")
        } catch {
            XCTFail("View model fail to initialise user list \(error)")
        }
    }
}
