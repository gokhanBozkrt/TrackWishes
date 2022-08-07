//
//  Binding-Onchange.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 7.08.2022.
//

import SwiftUI

extension Binding {
    
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
            
     

    }
}
