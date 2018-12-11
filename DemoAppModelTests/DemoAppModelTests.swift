//
//  DemoAppModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
import Moya
import RxMoya
import RxBlocking

@testable import DemoApp

class DemoAppModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGetUsers() {
        let provider = MoyaProvider<UserAPI>()
        do {
            let users = try provider.rx.request(.getUsers)
                .filterSuccessfulStatusCodes()
                .map([User].self)
                .toBlocking(timeout: 5)
                .first()

            XCTAssertNotNil(users)
            XCTAssert((users?.count ?? 0) > 0, "User list is empty")
        } catch {
            XCTFail("Error throwing when trying to get user list: \(error.localizedDescription)")
        }
    }

    func testGetUserDetail() {
        let provider = MoyaProvider<UserAPI>()
        do {
            let user = try provider.rx.request(.getUser(1))
                .filterSuccessfulStatusCodes()
                .map(User.self)
                .toBlocking(timeout: 5)
                .first()

            XCTAssertNotNil(user)
            XCTAssert(user?.email != nil && user?.email.isEmpty == false, "User email is nil or empty")
            XCTAssert(user?.username != nil && user?.username.isEmpty == false, "Username is nil or empty")
        } catch {
            XCTFail("Error throwing when trying to get user: \(error.localizedDescription)")
        }
    }

    func testGetUserPosts() {
        let provider = MoyaProvider<UserAPI>()
        do {
            let posts = try provider.rx.request(.getPosts(1))
                .filterSuccessfulStatusCodes()
                .map([Post].self)
                .toBlocking(timeout: 5)
                .first()

            XCTAssertNotNil(posts)
            XCTAssert((posts?.count ?? 0) > 0, "Posts list for user is empty")
        } catch {
            XCTFail("Error throwing when trying to get post list: \(error.localizedDescription)")
        }
    }

    func testGetUserAlbums() {
        let provider = MoyaProvider<UserAPI>()
        do {
            let albums = try provider.rx.request(.getAlbums(1))
                .filterSuccessfulStatusCodes()
                .map([Album].self)
                .toBlocking(timeout: 5)
                .first()

            XCTAssertNotNil(albums)
            XCTAssert((albums?.count ?? 0) > 0, "Album list for user is empty")
        } catch {
            XCTFail("Error throwing when trying to get album list: \(error.localizedDescription)")
        }
    }

    func testGetPostComments() {
        let userProvider = MoyaProvider<UserAPI>()
        let postProvider = MoyaProvider<PostAPI>()
        do {
            let posts = try userProvider.rx.request(.getPosts(1))
                .filterSuccessfulStatusCodes()
                .map([Post].self)
                .toBlocking(timeout: 5)
                .first()

            XCTAssertNotNil(posts)
            XCTAssert((posts?.count ?? 0) > 0, "Posts list for user is empty")

            let comments = try postProvider.rx.request(.getComments(posts!.first!.id))
                .filterSuccessfulStatusCodes()
                .map([Comment].self)
                .toBlocking(timeout: 5)
                .first()

            XCTAssertNotNil(comments)
            XCTAssert((comments?.count ?? 0) > 0, "Album list for user is empty")
        } catch {
            XCTFail("Error throwing when trying to get post comments: \(error.localizedDescription)")
        }
    }
}
