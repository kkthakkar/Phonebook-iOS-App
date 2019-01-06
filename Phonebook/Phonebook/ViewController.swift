//
//  ViewController.swift
//  Phonebook
//
//  Created by Kishan on 05/01/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var contacts: [NSManagedObject] = []

    @IBOutlet weak var tableViewData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetch()
        tableViewData.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func fetch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Contact")
        do {
            contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
    }
    
    func save(name: String, phoneNumber: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName:"Contact", in: managedObjectContext) else { return }
        let contact = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        do {
            try managedObjectContext.save()
            self.contacts.append(contact)
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
    
    func update(indexPath: IndexPath, name:String, phoneNumber: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let contact = contacts[indexPath.row]
        contact.setValue(name, forKey:"name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        do {
            try managedObjectContext.save()
            contacts[indexPath.row] = contact
        } catch let error as NSError {
            print("Couldn't update. \(error)")
        }
    }
    
    func delete(_ contact: NSManagedObject, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(contact)
        contacts.remove(at: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.value(forKey:"name") as? String
        cell.detailTextLabel?.text = contact.value(forKey:"phoneNumber") as? String
        
        return cell
    }
    
    //MARK: - Navigation
    
    //Unwind segue
    @IBAction func unwindToContactList(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? AddContactsVC {
            guard let name: String = viewController.textFname.text, let phoneNumber: String = viewController.textPhone.text else { return }
            if name != "" && phoneNumber != "" {
                if let indexPath = viewController.indexPathForContact {
                    update(indexPath: indexPath, name: name, phoneNumber: phoneNumber)
                } else {
                    save(name:name, phoneNumber:phoneNumber)
                }
            }
            tableViewData.reloadData()
        } else if let viewController = segue.source as? ContactDetailsVC {
            if viewController.isDeleted {
                guard let indexPath: IndexPath = viewController.indexPath else { return }
                let contact = contacts[indexPath.row]
                delete(contact, at: indexPath)
                tableViewData.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetailSegue" {
            guard let navViewController = segue.destination as? UINavigationController else { return }
            guard let viewController = navViewController.topViewController as? ContactDetailsVC else { return }
            guard let indexPath = tableViewData.indexPathForSelectedRow else { return }
            let contact = contacts[indexPath.row]
            viewController.contact = contact
            viewController.indexPath = indexPath
        }
    }
}
