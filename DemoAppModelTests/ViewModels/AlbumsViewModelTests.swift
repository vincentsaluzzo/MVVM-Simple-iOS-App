//
//  AlbumsViewModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class AlbumsViewModelTests: XCTestCase {

    var viewModel: AlbumsViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = AlbumsViewModel(User(id: 1, name: "Vincent", username: "vincent", email: "vs@gmail.com", address: nil, phone: nil, website: nil, company: nil))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAlbumsList() {

        do {
            _ = try viewModel.loading.asObservable()
                .skip(1)
                .toBlocking(timeout: 5)
                .first()!

        } catch {
            XCTFail("Failing to finish loading view model \(error)")
        }
        do {
            let albums = try viewModel.albums.asObservable()
                .toBlocking(timeout: 5)
                .first()!

            XCTAssert(albums.isEmpty == false, "Album list is empty in view model")
        } catch {
            XCTFail("View model fail to initialise album list \(error)")
        }
    }
}
