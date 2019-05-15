//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by Keawa Rozet on 4/23/19.
//  Copyright © 2019 Keawa Rozet. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {

    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a request
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        // Initialize results controller
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController (
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        resultsController.delegate = self
        
        do {
            // Fetch data
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        // Configure the cell...
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "trashcan")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "checkmark")
        action.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTodoViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
    }
}

extension TodoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

            switch type {
                case .insert:
                    if let indexPath = newIndexPath {
                        tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                default:
                    break
            }
    }
}
