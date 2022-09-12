//
//  DevelopmentTests.swift
//  TrackWishesTests
//
//  Created by Gokhan Bozkurt on 12.09.2022.
//

import CoreData
import XCTest
@testable import TrackWishes

class DevelopmentTests: BaseTestCase {

  
    func testTestSampleDataCreationWorks() throws {
        try dataController.createSampleData()
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()),5,"There should be 5 sample projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()),50,"There should be 50 sample items")
    }
    
    func testDeleteAllClearsEverything() throws {
       try dataController.createSampleData()
        dataController.deleteAll()
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()),0,"There should be 0 sample projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()),0,"There should be 0 sample items")
    }
    
    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "The example project should be closed")
    }

    func testExampleItemsHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3,"The example item should be high priority")
    }
}
