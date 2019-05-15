//
//  AddTodoViewController.swift
//  TodoApp
//
//  Created by Keawa Rozet on 4/23/19.
//  Copyright © 2019 Keawa Rozet. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    // MARK: Outlets
    @IBOutlet weak var userTaskTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        userTaskTextView.becomeFirstResponder()
        
        if let todo = todo {
            userTaskTextView.text = todo.title
            //userTaskTextView.text = todo.title
            prioritySegmentedControl.selectedSegmentIndex = Int(todo.priority)
        }
    }
    
    // MARK: Actions
    
    @objc func keyboardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue
            else {
                return
            }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        userTaskTextView.resignFirstResponder()
    }
    
    @IBAction func canel(_ sender: UIButton) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: UIButton) {
        guard let title = userTaskTextView.text, !title.isEmpty else {
            // tell user you can't save empty Todo's
            return
        }
        
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(prioritySegmentedControl.selectedSegmentIndex)
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(prioritySegmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            print("Error saving todo: \(error)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddTodoViewController: UITextViewDelegate {
   
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden {
            userTaskTextView.text.removeAll()
            userTaskTextView.textColor = .white
            doneButton.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NSManagedObject {
    convenience init (usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
}
