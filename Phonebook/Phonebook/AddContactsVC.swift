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
    @IBOutlet weak var textEmail: UITextField!
    
    override func viewDidLoad() {
        
        labelTitle.text = titleText
        if let contact = self.contact {
            textFname.text = contact.value(forKey: "name") as? String
            textPhone.text = contact.value(forKey: "phoneNumber") as? String
            textEmail.text = contact.value(forKey: "email") as? String
        }

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            perform(#selector(buttonCancel(_:)), with: nil, afterDelay: 0.1)
        }
    }
    
    // MARK:- AlertView
    func showAlert(message:String) {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Email and Phone Validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    // MARK:- Button Actions
    
    @IBAction func buttonCancel(_ sender: AnyObject) {
        textFname.text = nil
        textPhone.text = nil
        textEmail.text = nil
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    @IBAction func buttonDone(_ sender: AnyObject) {
        
        if textFname.text?.isEmpty == true {
            self.showAlert(message: "Please enter full name")
        } else if textPhone.text?.isEmpty == true {
            self.showAlert(message: "Please enter phone number")
        } else if !isValidPhone(value: textPhone.text!) {
            self.showAlert(message: "Please enter valid phone number")
        } else if textEmail.text?.isEmpty == false {
            if !isValidEmail(testStr: textEmail.text!) {
                self.showAlert(message: "Please enter valid email address")
            } else {
                performSegue(withIdentifier: "unwindToContactList", sender: self)
            }
        } else {
            performSegue(withIdentifier: "unwindToContactList", sender: self)
        }
    }
}
