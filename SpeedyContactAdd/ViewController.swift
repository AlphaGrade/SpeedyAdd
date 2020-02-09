//
//  ViewController.swift
//  SpeedyContactAdd
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//


import UIKit
import Contacts
import WatchConnectivity
import UserNotifications

class TableViewController: UIViewController, WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session is activated")
    }
    
    // MARK: Table View Declaration
    @IBOutlet var tableView: UITableView!
    
    
    var session: WCSession!
    var window: UIWindow?

    var numberContact = String()
    var contacts = [String]()
    var contact = String()
    
    // Establishes WCSession to Watch
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
   

    
    // MARK: WCSession That receives message from Phone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if message.count == 2 {
            
            // Receive messages from watch
            
            guard let recipNumberString = message["PhoneNumber"] else {return}
            guard let recipNameString = message["RecipientName"] else {return}
            //Combines String into Name and Phone number
            
            let tableViewContact = ("\(recipNameString) \(recipNumberString)")
            
            
            // Split String into first name and last name
            
            let fullName = ("\(recipNameString)")
            let fullNameArr = fullName.components(separatedBy: " ")
            
            let firstName = fullNameArr[0]
            let lastName = fullNameArr[1]
            
            // Create New Contact
            
            let newContact = CNMutableContact()
            newContact.givenName = ("\(firstName)")
            newContact.familyName = ("\(lastName)")
            
            let number = CNPhoneNumber(stringValue: ("\(recipNumberString)"))
            
            newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: number)]
            
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier:nil)
            try! store.execute(saveRequest)
            add(contact: tableViewContact)
            
        } else {
            
            var messageCount = 0
            messageCount = message.count / 2
            print(messageCount)
            
            var recipNumberString = ""
            var recipNameString = ""
            
            for number in 1...messageCount {
                
                recipNumberString = message["numberString\(number)"] as! String
                recipNameString = message["fullNameString\(number)"] as! String
                
                //Combines String into Name and Phone number
                
                let tableViewContact = ("\(recipNameString) \(recipNumberString)")
                
                let fullName = ("\(recipNameString)")
                let fullNameArr = fullName.components(separatedBy: " ")
                
                let firstName = fullNameArr[0]
                let lastName = fullNameArr[1]
                
                // Creates New Contact
                
                let newContact = CNMutableContact()
                newContact.givenName = ("\(firstName)")
                newContact.familyName = ("\(lastName)")
                
                let number = CNPhoneNumber(stringValue: ("\(recipNumberString)"))
                
                newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: number)]
                
                let store = CNContactStore()
                let saveRequest = CNSaveRequest()
                saveRequest.add(newContact, toContainerWithIdentifier:nil)
                try! store.execute(saveRequest)
                
                add(contact: tableViewContact)
            }
            
        }
        
        
        
        
    }
    
    func add(contact: String) {

        let index = 0
        contacts.insert(contact, at: index)
        
        if tableView == nil {
            print("doesn't contain a value!")
        } else {
            print("Contains a value.")
            
        }
  
        print(contacts)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .left)
        }

}


extension TableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        DispatchQueue.main.async {
            let contact = self.contacts[indexPath.row]
            cell.textLabel?.text = contact
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard editingStyle == .delete else { return }
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    
    
    
    
    
    
}
