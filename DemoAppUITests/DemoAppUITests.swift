//
//  DemoAppUITests.swift
//  DemoAppUITests
//
//  Created by Vincent Saluzzo on 11/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import XCTest

class DemoAppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // swiftlint:disable function_body_length
    func testFullUseOfApp() {

        // Start tapp
        let app = XCUIApplication()

        // Select the first screen and wait collectionView filled (service response)
        let mainView = app.otherElements.containing(.navigationBar, identifier: "Users").element
        let userCollectionCells = mainView.collectionViews.children(matching: .cell)
        guard userCollectionCells.firstMatch.waitForExistence(timeout: 5) else {
            return XCTFail("Users take too more time to be displayed")
        }

        // Take the first cell and retrieve name writed in
        let firstUserCell = userCollectionCells.firstMatch
        let username = firstUserCell.staticTexts["nameLabel"].label

        // Select the first cell and wait displaying the user detail screen for appropriate user
        firstUserCell.tap()
        let userDetailView = app.otherElements.containing(.navigationBar, identifier: username).element
        guard userDetailView.waitForExistence(timeout: 5) else {
            return XCTFail("User detail take too more time to be displayed")
        }

        // Wait for user detail loading, tap on album button and waiting album view displaying
        guard userDetailView.collectionViews.cells.firstMatch.waitForExistence(timeout: 5) else {
            return XCTFail("User detail collection view undisplayed correctly")
        }
        userDetailView.buttons["albumButton"].tap()
        let albumsView = app.otherElements.containing(.navigationBar, identifier: "Albums").element
        guard albumsView.waitForExistence(timeout: 5) && albumsView.collectionViews.cells.firstMatch.waitForExistence(timeout: 5) else {
            return XCTFail("Album list take too more time to be displayed")
        }

        // Go to first album, wait for displaying it, wait for photo list and select it and wait for imageLoading
        albumsView.collectionViews.cells.firstMatch.tap()

        let albumView = app.otherElements.containing(.navigationBar, identifier: nil).element
        guard albumView.waitForExistence(timeout: 5) && albumView.collectionViews.cells.firstMatch.waitForExistence(timeout: 5) else {
            return XCTFail("Photos list take too more time to be displayed")
        }

        albumView.collectionViews.cells.firstMatch.tap()
        let photoView = app.otherElements["photoView"]
        guard photoView.waitForExistence(timeout: 5) else {
            return XCTFail("Photo take too more time to be displayed")
        }

        // Back to detail user
        photoView.buttons["✕"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Select a post, save comment number and go to comment page to check if comment number is ok
        let cell = userDetailView.collectionViews.cells.containing(.button, identifier: "commentNumberButton").firstMatch
        let commentText = cell.buttons["commentNumberButton"].label
        let commentNumberString = commentText.replacingOccurrences(of: " comment(s)", with: "").replacingOccurrences(of: " ", with: "")
        guard let commentNumber = Int(commentNumberString) else {
            return XCTFail("Can't detect number of comment in comment button from a post cell")
        }

        cell.tap()

        let commentsView = app.otherElements.containing(.table, identifier: nil).element
        guard commentsView.waitForExistence(timeout: 5) && commentsView.tables.cells.firstMatch.waitForExistence(timeout: 5) else {
            return XCTFail("Comment list take too more time to be displayed")
        }

        XCTAssert(commentsView.tables.cells.count == commentNumber, "Comment number in detail don't correspond to comment number displayed in comments list")

        commentsView.textViews["postCommentTextView"].tap()
        commentsView.textViews["postCommentTextView"].typeText("Super comment !")
        commentsView.buttons["postCommentButton"].tap()
        guard app.alerts["Comment sent !"].waitForExistence(timeout: 5) else {
            return XCTFail("Alert of confirmation for posting comment doesn't appear")
        }
    }
    // swiftlint:enable function_body_length
}
