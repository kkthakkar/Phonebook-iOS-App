//
//  AddContactsVC.swift
//  Phonebook
//
//  Created by Kishan on 06/01/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddContactsVC : UIViewController {
  
    var titleText = "Add Contact"
    var contact: NSManagedObject? = nil
    var indexPathForContact: IndexPath? = nil

    // MARK:- TextField Outlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFname: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    
    override func viewDidLoad() {

        labelTitle.text = titleText
        if let contact = self.contact {
            textFname.text = contact.value(forKey: "name") as? String
            textPhone.text = contact.value(forKey: "phoneNumber") as? String
        }
        
    }
    

    // MARK:- Button Actions
    
    @IBAction func buttonCancel(_ sender: AnyObject) {
        textFname.text = nil
        textPhone.text = nil
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    @IBAction func buttonDone(_ sender: AnyObject) {
    
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
}
