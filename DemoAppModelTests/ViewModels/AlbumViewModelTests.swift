//
//  AlbumViewModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class AlbumViewModelTests: XCTestCase {
    var viewModel: AlbumViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = AlbumViewModel(Album(userId: 1, id: 1, title: "Album photo"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelPresentationIsOk() {
        XCTAssert(viewModel.title == "Album photo", "title isn't good in presentation view model")
    }

    func testPhotosList() {

        do {
            let loading = try viewModel.loading.asObservable()
                .skip(1)
                .toBlocking(timeout: 5)
                .first()!
            XCTAssertFalse(loading, "Loading not finished before timeout (too long to respond ?)")
        } catch {
            XCTFail("Failing to finish loading view model \(error)")
        }
        do {
            let photos = try viewModel.photos.asObservable()
                .toBlocking(timeout: 4)
                .first()!

            XCTAssert(photos.isEmpty == false, "Photo list is empty in view model")
        } catch {
            XCTFail("View model fail to initialise photo list \(error)")
        }
    }

}
