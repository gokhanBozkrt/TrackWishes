//
//  Sequence-Sorting.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 13.08.2022.
//

import Foundation
import SwiftUI

extension Sequence {
    // MARK: SWIFT WAY USING KEYPATH TO SORT
    func sorted<Value>(by keyPath: KeyPath<Element,Value>, using areInIncreasingOrder: (Value,Value) throws -> Bool) rethrows -> [Element] {
        try self.sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element,Value>) -> [Element] {
         self.sorted(by: keyPath,using: <)
    }
    

    
    //MARK: SORT BY NSSORTDESCRIPTOR OBJECTIVE-C WAY
    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
        self.sorted {
            sortDescriptor.compare($0, to: $1) == .orderedAscending
        }
    }
    //MARK: SORT BY NSSORTDESCRIPTOR OBJECTIVE-C WAY FOR ARRAYS
    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        self.sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                case .orderedSame:
                    continue
                }
            }
            return false
        }
    }
}
