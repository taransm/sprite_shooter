//
//  Sprite_ShooterUITestsLaunchTests.swift
//  Sprite ShooterUITests
//
//  Created by Tarandeep Mandhiratta and Roshan Chaudhari on 2022-04-06.
//

import XCTest

class Sprite_ShooterUITestsLaunchTests: XCTestCase {

    override class var runsForEachEnemyApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
