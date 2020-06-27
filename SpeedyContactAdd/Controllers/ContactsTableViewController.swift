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

class ContactsTableViewController: UITableViewController, WCSessionDelegate {
    
    var session: WCSession!
    var window: UIWindow?
    var contacts: [Contacts] = []
    let contactsDefault = UserDefaults.standard
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return formatter
    }()
    
    let checkIfUserDefaultExist:((String) -> Bool) = { key in
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    // Establishes WCSession to Watch
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self 
            session.activate()
        }
        if checkIfUserDefaultExist("SavedContacts") == true {
            restoreSavedContacts()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("There was an error: \(error)")
        }
    }
    // MARK: Receive Message Data from WatchOS
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        let decoder = JSONDecoder()
        do {
            let contactData = try decoder.decode([Contacts].self, from: messageData)
            // TODO: - replace For Loop with map
            // contacts? = contactData.map({$0})
            for contact in contactData {
                contacts.append(contact)
                update(saved: contact)
                add(contact: contact.name, phone: contact.phoneNumber)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error decoding data: \(error)")
        }
        
    }
    
    // MARK: Table View Declaration
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") else { return UITableViewCell() }
        let contact = self.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = self.dateFormatter.string(from: contact.date)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        self.contacts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        // TODO: - implement the delete method to remove contact from User Defaults
        update(saved: contacts)
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetail" {
            if let indexPath = tableView.indexPathForSelectedRow, let vc = segue.destination as? ContactsDetailViewController {
                vc.contact = contacts[indexPath.row]
            }
        }
    }
    
    
    // MARK: - Actions
    // Adds Contact to Phone List
    func add(contact to: String, phone: String) {
        //Splits Name into first name / last name
        let fullNameSplit = to.components(separatedBy: " ")
        
        let firstName = fullNameSplit[0]
        let lastName = fullNameSplit[1]
        
        // Creates contact in phone list
        
        let newContact = CNMutableContact()
        newContact.givenName = ("\(firstName)")
        newContact.familyName = ("\(lastName)")
        
        let number = CNPhoneNumber(stringValue: ("\(phone)"))
        
        newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: number)]
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)}
    //Runs during ViewDidLoad
    func restoreSavedContacts() {
        let data = contactsDefault.object(forKey: "SavedContacts") as! Data
        guard let decodedData = try? JSONDecoder().decode([Contacts].self, from: data) else { return }
        contacts.append(contentsOf: decodedData)
    }
    // Adds new contact to User Defaults
    func update(saved contact: Contacts) {
        let encodedData = try? JSONEncoder().encode(contacts)
        contactsDefault.set(encodedData, forKey: "SavedContacts")
    }
    func update(saved contacts: [Contacts]) {
        let encodedData = try? JSONEncoder().encode(contacts)
        contactsDefault.set(encodedData, forKey: "SavedContacts")
    }
}

