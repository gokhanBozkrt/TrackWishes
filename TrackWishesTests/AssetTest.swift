//
//  AssetTest.swift
//  TrackWishesTests
//
//  Created by Gokhan Bozkurt on 6.09.2022.
//

import XCTest
@testable import TrackWishes

class AssetTest: XCTestCase {

    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color),"Failed to load color \(color) from asset catalog")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty,"Failed to load awards from JSON")
    }
}
