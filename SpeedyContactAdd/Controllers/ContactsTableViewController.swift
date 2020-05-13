//
//  ContactsTableViewController.swift
//  SpeedyContactAdd
//
//  Created by Joe on 5/1/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import Contacts
import WatchConnectivity
import UserNotifications

class ContactsTableViewController: UITableViewController {

    var session: WCSession!
    var window: UIWindow?
    
    var contacts = [Contacts]()
    
//    var numberContact = String()
//    var contacts = [String]()
//    var contact = String()
    
    // Establishes WCSession to Watch
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self as? WCSessionDelegate
            session.activate()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    // MARK: Receive Message Data from WatchOS
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        let decoder = JSONDecoder()
        do {
            let contactData = try decoder.decode([Contacts].self, from: messageData)
            for contact in contactData {
                       contacts.append(contact)
                   }
        } catch {
            print("Error decoding data: \(error)")
        }
       
    }

    // MARK: WCSession That receives message from Phone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        for contact in message {
            let number = contact.key
            let name = contact.value
            
            //Combines String into Name and Phone number
            
            let tableViewContact = ("\(name) \(number)")
            
            
            // Split String into first name and last name
            
            let fullName = ("\(name)")
            let fullNameArr = fullName.components(separatedBy: " ")
            
            let firstName = fullNameArr[0]
            let lastName = fullNameArr[1]
            
            // Create New Contact
            
            let newContact = CNMutableContact()
            newContact.givenName = ("\(firstName)")
            newContact.familyName = ("\(lastName)")
            
            let newNumber = CNPhoneNumber(stringValue: ("\(number)"))
            
            newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: newNumber)]
            
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier:nil)
            try! store.execute(saveRequest)
            add(contact: tableViewContact)
        }
    }
    // Adds contact to TableView
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
    
    // MARK: Table View Declaration
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        DispatchQueue.main.async {
            let contact = self.contacts[indexPath.row]
            cell.textLabel?.text = contact
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard editingStyle == .delete else { return }
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}



