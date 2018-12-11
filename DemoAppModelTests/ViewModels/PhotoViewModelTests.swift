//
//  PhotoViewModelTests.swift
//  DemoAppModelTests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import DemoApp

class PhotoViewModelTests: XCTestCase {

    var viewModel: PhotoViewModeling!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = PhotoViewModel(Photo(albumId: 1, id: 1, title: "Super photo", url: "https://fakeimg.pl/1000", thumbnailUrl: "https://fakeimg.pl/300"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelPresentationIsOk() {
        XCTAssert(viewModel.title == "Super photo", "title isn't good in presentation view model")
        XCTAssert(viewModel.thumbnail.isEmpty == false, "thumbnail image isn't good in presentation view model")
        XCTAssert(viewModel.url.isEmpty == false, "thumbnail image isn't good in presentation view model")
    }

}
