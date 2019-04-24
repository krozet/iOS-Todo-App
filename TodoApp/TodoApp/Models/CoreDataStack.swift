//
//  CoreDataStack.swift
//  TodoApp
//
//  Created by Keawa Rozet on 4/24/19.
//  Copyright © 2019 Keawa Rozet. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores {
             (description, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
        }
        return container
    }
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
