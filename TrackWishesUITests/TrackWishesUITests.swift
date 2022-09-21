//
//  TrackWishesUITests.swift
//  TrackWishesUITests
//
//  Created by Gökhan Bozkurt on 18.09.2022.
//

import XCTest

 class TrackWishesUITests: XCTestCase {
     var app: XCUIApplication!
    override func setUpWithError() throws {
        continueAfterFailure = false
          app = XCUIApplication()
          app.launchArguments = ["enable-testing"]
          app.launch()
    }

    func testAppHas4Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4,"There should be 4 tabs in the app.")
    }
     func testOpenTabAddsItems() {
         app.buttons["Open"].tap()
         XCTAssertEqual(app.tables.cells.count, 0,"There should be no list rows initially")
         
         for tapCount in 1...5 {
             app.buttons["Add"].tap()
             XCTAssertEqual(app.tables.cells.count, tapCount,"There should be \(tapCount) list row(s) initially.")
         }
     }
     func testAddingItemInsertsRows() {
         app.buttons["Open"].tap()
         XCTAssertEqual(app.tables.cells.count, 0,"There should be no list rows initially")
         
         app.buttons["Add New Project"].tap()
         XCTAssertEqual(app.tables.cells.count, 1,"There should be 1 list row after adding a project.")
         
         app.buttons["Add New Item"].tap()
         XCTAssertEqual(app.tables.cells.count, 2,"There should be 2 list row after adding an item.")
     }
     
     func testEditingProjectUpdatesCorrectly() {
         app.buttons["Open"].tap()
         XCTAssertEqual(app.tables.cells.count, 0,"There should be no list rows initially")
         
         app.buttons["Add New Project"].tap()
         XCTAssertEqual(app.tables.cells.count, 1,"There should be 1 list row after adding a project.")
         
         app.buttons["Compose"].tap()
         app.textFields["Project name"].tap()
         
         app.keys["space"].tap()
         app.keys["more"].tap()
         app.keys["2"].tap()
         app.buttons["Return"].tap()
         
         app.buttons["Open Projects"].tap()
         
         XCTAssertTrue(app.buttons["Compose"].exists,"The new prooject name should be visible in the list.")
        
     }
     
     func testEditingItemUpdatesCorrectly() {
       
         // Go to Open projects and add one project and one item before the test.
         testAddingItemInsertsRows()
         
         app.buttons["New Item"].tap()
         app.textFields["Item name"].tap()
         
         app.keys["space"].tap()
         app.keys["more"].tap()
         app.keys["2"].tap()
         app.buttons["Return"].tap()
         
         app.buttons["Open Projects"].tap()
         
         XCTAssertTrue(app.buttons["New Item 2"].exists,"The new item name should be visible in the list.")
        
     }

     func testAllAwardsShowLockedAlert() {
         app.buttons["Awards"].tap()
         
         for award in app.scrollViews.buttons.allElementsBoundByIndex {
             award.tap()
             XCTAssertTrue(app.alerts["Locked"].exists,"There should be a locked alert showing for awards.")
             app.buttons["OK"].tap()
             
         }
     }
     
}

