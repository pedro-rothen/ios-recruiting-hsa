//
//  MoviesViewControllerUITests.swift
//  MoviesUITests
//
//  Created by Pedro on 28-07-24.
//

import XCTest

final class MoviesViewControllerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testShowsActivityIndicator() {
        let activityIndicator = app.activityIndicators.firstMatch
        XCTAssert(activityIndicator.exists)
    }

    override func tearDown() {
        app = nil
    }
}
