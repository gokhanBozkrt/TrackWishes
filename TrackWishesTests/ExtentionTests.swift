//
//  ExtentionTests.swift
//  TrackWishesTests
//
//  Created by Gokhan Bozkurt on 14.09.2022.
//

import XCTest
@testable import TrackWishes
import SwiftUI


class ExtentionTests: XCTestCase {
    func testSequenceKeypathSortingCustom() {
        let items = [1,3,5,4,2]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1,2,3,4,5],"The sorted numbers must be ascending")
    }

    func testSequenceSort() {
        // swifltint: disable: next nesting
        struct Product: Equatable {
            let name: String
        }
        let products: [Product] =
            [
            Product(name: "Car"),
            Product(name: "Apple"),
            Product(name: "Zipper"),
            Product(name: "Sheet"),
            Product(name: "Pen")
        ]
        let sortedProducts1 =
        [
            Product(name: "Zipper"),
            Product(name: "Sheet"),
            Product(name: "Pen"),
            Product(name: "Car"),
            Product(name: "Apple")
        ]
        let sortedProducts2 = products.sorted(by: \.name) {
            $0 > $1
        }
        
        XCTAssertEqual(sortedProducts2, sortedProducts1,"They sould be true reverse alpabeticllay")
        
       }
    
    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty,"Awards.json should decode to a non-empty array.")
    }
    
    func testDecodingString() {
        let bundle = Bundle(for: ExtentionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data,"They bear striking similarity on their beauty.","The string must match the content of DecodableString.json")
        
    }
    func testDecodingdictionary() {
        let bundle = Bundle(for: ExtentionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        XCTAssertEqual(data.count,3,"There should be 3 items")
        XCTAssertEqual(data["One"],1,"The dictionary should contain Int to String mappings.")
    }
    
    func testBindingOnChangeCallsFunction() {
        // GIVEN
        var onChangeFunctionRun = false
        
        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }
        var storedValue = ""
        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
            )
        let changedBinding = binding.onChange(exampleFunctionToCall)
        // WHEN
        changedBinding.wrappedValue = "Test"
        // THEN
        XCTAssertTrue(onChangeFunctionRun,"The onChange function must run when the binding is changed")
    }
    
}
