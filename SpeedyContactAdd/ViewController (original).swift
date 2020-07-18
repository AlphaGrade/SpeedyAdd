//
//  ViewController.swift
//  SpeedyContactAdd
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//


import UIKit
import Foundation
import Contacts
import WatchConnectivity
import CoreData

class PhoneSessionManager: NSObject {
    // Instantiate the Singleton
    static let sharedManager = PhoneSessionManager()
    private override init() {
        super.init()
    }

    // Keep a reference for the session,
    // which will be used later for sending / receiving data
    private let session = WCSession.default

//    func startSession() {
//                if WCSession.isSupported() {
//                    let session = WCSession.default
//                    session.delegate = self as! WCSessionDelegate
//                   session.activate()
//                }
//
//    }
    
//     func session(_ session : WCSession!, didReceiveUserInfo message: [String : Any]) {
//
//        // Receive messages from watch
//    func transfer(){
//        let recipNumberString = message["PhoneNumber"]!
//
//        let recipNameString = message["RecipientName"]!
//
//
//        // Split String into first name and last name
//
//        let fullName = ("\(recipNameString)")
//        let fullNameArr = fullName.components(separatedBy: " ")
//
//        let firstName = fullNameArr[0]
//        let lastName = fullNameArr[1]
//
//        //        self.firstNameLabel.text = ("\(firstName)")
//        //        self.lastNameLabel.text = ("\(lastName)")
//
//        //  Determines if the Contact name or Number is already in the Contact List.
//
//        // Updates Current Contact or Number
//
//        // Creates New Contact (If Neccesary)
//
//
//        let newContact = CNMutableContact()
//        newContact.givenName = ("\(firstName)")
//        newContact.familyName = ("\(lastName)")
//
//
//        let number = CNPhoneNumber(stringValue: ("\(recipNumberString)"))
//
//        newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: number)]
//
//        let store = CNContactStore()
//        let saveRequest = CNSaveRequest()
//        saveRequest.add(newContact, toContainerWithIdentifier:nil)
//        try! store.execute(saveRequest)
//
//        // Merge Strings together to display in app (Table View)
//
//        }
//    }
//}

//class TableViewController: UITableViewController {
//
//
//
//
//    var listItems = [NSManagedObject]()
//
//
//    @IBOutlet weak var phoneNumberLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var firstNameLabel: UILabel!
//    @IBOutlet weak var lastNameLabel: UILabel!
//    @IBOutlet weak var contactNameList: UITableView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        if WCSession.isSupported() {
////            let session = WCSession.default
////            session.delegate = self
////           session.activate()
////        }
//
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(TableViewController.addItem))
//
//
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntity")
//
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            listItems = results as! [NSManagedObject]
//        }
//        catch {
//            print("Error")
//        }
//
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
//
//        managedContext.delete(listItems[indexPath.row])
//        listItems.remove(at: indexPath.row)
//        self.tableView.reloadData()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return listItems.count
//    }
//
//    //TableView Setup and the coredata attribs it displays
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
//
//        let item = listItems[indexPath.row]
//
//        cell.textLabel?.text = (item.value(forKey: "lastNameCore") as! String)
//
//        return cell
//    }
//
//
//
//
//    //func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//    //  func session(_ session: WCSession, didFinish message: WCSessionUserInfoTransfer, error: Error?) {
//
//    func session(_ session : WCSession, didReceiveUserInfo message: [String : Any]) {
//
//        // Receive messages from watch
//
//        let recipNumberString = message["PhoneNumber"]!
//
//        let recipNameString = message["RecipientName"]!
//
//        //        self.phoneNumberLabel.text = ("\(recipNumberString)")
//        //        self.nameLabel.text = ("\(recipNameString)")
//
//        // Split String into first name and last name
//
//        let fullName = ("\(recipNameString)")
//        let fullNameArr = fullName.components(separatedBy: " ")
//
//        let firstName = fullNameArr[0]
//        let lastName = fullNameArr[1]
//
//        //        self.firstNameLabel.text = ("\(firstName)")
//        //        self.lastNameLabel.text = ("\(lastName)")
//
//        //  Determines if the Contact name or Number is already in the Contact List.
//
//
//
//        // Updates Current Contact or Number
//
//
//
//        // Creates New Contact (If Neccesary)
//
//
//        let newContact = CNMutableContact()
//        newContact.givenName = ("\(firstName)")
//        newContact.familyName = ("\(lastName)")
//
//
//        let number = CNPhoneNumber(stringValue: ("\(recipNumberString)"))
//
//        newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: number)]
//
//
//
//        let store = CNContactStore()
//        let saveRequest = CNSaveRequest()
//        saveRequest.add(newContact, toContainerWithIdentifier:nil)
//        try! store.execute(saveRequest)
//
//        // Merge Strings together to display in app (Table View)
//
//
//        let contactUpload = "\(recipNameString) \(recipNumberString)"
//
//
//        //Store Data in App Core Data
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
//        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
//
//        item.setValue(contactUpload, forKey: "lastNameCore")
//        do {
//
//            try managedContext.save()
//
//            listItems.append(item)
//        }
//
//        catch {
//
//            print("error")
//
//        }
//
//        // Display in TableView Controller.
//
//
//        self.tableView.reloadData()
//
//
//
//        // Delete data in App Core Data
//
//
//    }
//
//    // Manually add contact in iOS application
//
//    @objc func addItem(){
//        let alertController = UIAlertController(title: "Add New Contact", message: "Add Name and Number", preferredStyle: .alert)
//
//        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: ({
//            (_) in
//            if let field  = alertController.textFields![0] as? UITextField {
//
//                self.saveItem(itemToSave: field.text!)
//                self.tableView.reloadData()
//            }
//            }
//        ))
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
//
//        alertController.addTextField(configurationHandler: {
//            (textField) in
//
//            (textField.placeholder = "insert Text Here")
//
//        })
//
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true, completion: nil)
//
//    }
//
//
//
//
//
//
//    // this function saves data to Core Data (Will eventually remove from app)
//    func saveItem(itemToSave : String){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
//
//        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
//
//        item.setValue(itemToSave, forKey: "lastNameCore")
//
//        do {
//
//            try managedContext.save()
//
//            listItems.append(item)
//        }
//
//        catch {
//
//            print("error")
//
//        }
//
//
//    }

}
    

    
    



