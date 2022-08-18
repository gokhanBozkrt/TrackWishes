//
//  AwardsView.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 18.08.2022.
//

import SwiftUI

struct AwardsView: View {
    static let tag: String? = "Awards"
    @EnvironmentObject var dataController: DataController
    
    @State private var selectedAward = Award.example
    @State private var showingAlertDetails = false
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAlertDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                               .foregroundColor(
                                dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5))
                            
                        }

                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(dataController.hasEarned(award: selectedAward) ? "Unlock:\(selectedAward.name)" : "Locked" , isPresented: $showingAlertDetails) {
            Button("OK") { }
        } message: {
            Text("\(selectedAward.description)")
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
