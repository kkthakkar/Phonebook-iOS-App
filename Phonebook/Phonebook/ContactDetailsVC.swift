//
//  ContactDetailsVC.swift
//  Phonebook
//
//  Created by Kishan on 06/01/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContactDetailsVC : UIViewController {
    
    var contact: NSManagedObject? = nil
    var isDeleted: Bool = false
    var indexPath: IndexPath? = nil

    @IBOutlet weak var labelFName: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelFName.text = contact?.value(forKey:"name") as? String
        labelNumber.text = contact?.value(forKey:"phoneNumber") as? String
        labelEmail.text = contact?.value(forKey: "email") as? String
 
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            perform(#selector(buttonDone(_:)), with: nil, afterDelay: 0.1)
        }
    }
    
    // MARK:- Button Actions
    
    @IBAction func buttonCall(_ sender: AnyObject) {
    
        if let url = URL(string: "tel://\(labelNumber.text)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func buttonDone(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }

    @IBAction func deleteContact(_ sender: Any) {

        let alert = UIAlertController(title: "Alert", message: "Are you sure want to delete this contact ?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        
            self.isDeleted = true
            self.performSegue(withIdentifier: "unwindToContactList", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    
     }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            guard let viewController = segue.destination as? AddContactsVC else { return }
            viewController.titleText = "Edit Contact"
            viewController.contact = contact
            viewController.indexPathForContact = self.indexPath!
        }
    }
}
