//
//  HomeViewModel.swift
//  TrackWishes
//
//  Created by Gökhan Bozkurt on 2.10.2022.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject,ObservableObject,NSFetchedResultsControllerDelegate {
        
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>
        
        var dataController: DataController
        @Published var projects = [Project]()
        @Published var items = [Item]()
        @Published var selectedItem: Item?
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
            projectRequest.predicate = NSPredicate(format: "closed = false")
            
            projectsController = NSFetchedResultsController(fetchRequest: projectRequest, managedObjectContext: dataController.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
          
            
            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
            let completedPredicate = NSPredicate(format: "completed = false")
            let opentPredicate = NSPredicate(format: "project.closed = false")
            itemRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate,opentPredicate])
            itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
            itemRequest.fetchLimit = 10
            
            itemsController = NSFetchedResultsController(fetchRequest: itemRequest, managedObjectContext: dataController.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            super.init()
            projectsController.delegate = self
            itemsController.delegate = self
            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to load data")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            }
             if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
        
        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }
        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }
        
        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
        
        func selectItem(with identifier: String) {
            selectedItem = dataController.item(with: identifier)
        }
    }
}


