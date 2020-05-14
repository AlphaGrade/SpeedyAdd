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
    
    // Establishes WCSession to Watch
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self as? WCSessionDelegate
            session.activate()
        }
        testContact()
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
    
    func testContact() {
        let aaron = Contacts(name: "Tim Apple",
                             phoneNumber: "3128675309",
                             longitude: 37.332279,
                             latitude: -122.010979,
                             date: "05/12/20")
        contacts.append(aaron)
    }


    // MARK: Table View Declaration

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") else {return UITableViewCell()}
        DispatchQueue.main.async {
            let contact = self.contacts[indexPath.row]
            cell.textLabel?.text = contact.name
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


// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetail" {
            if let indexPath = tableView.indexPathForSelectedRow, let vc = segue.destination as? ContactsDetailViewController {
                vc.contact = contacts[indexPath.row]
            }
        }
    }
}

