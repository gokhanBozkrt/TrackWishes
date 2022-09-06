//
//  TrackWishesTests.swift
//  TrackWishesTests
//
//  Created by Gokhan Bozkurt on 6.09.2022.
//

import CoreData
import XCTest
@testable import TrackWishes

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
        
    }


}
