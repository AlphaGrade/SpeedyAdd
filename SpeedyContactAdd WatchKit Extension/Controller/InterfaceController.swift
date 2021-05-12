//
//  InterfaceController.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//

import CoreLocation
import UIKit
import WatchConnectivity
import WatchKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    override func awake(withContext context: Any?) {
            if(WCSession.isSupported()){
            self.session = WCSession.default
            session.delegate = self
            self.session.activate()
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
        if let error = error {
            print("There was an error: \(error)")
            return
        }
    }
    
    @IBOutlet var lblPhoneNumber: WKInterfaceLabel!
    @IBOutlet var lblName: WKInterfaceLabel!
    
    var session: WCSession!
    
    var contacts: [Contacts] = []
    var numberStore = String()
    var recipNameString = String()
    let contactsDefault = UserDefaults.standard
    let checkIfUserDefaultExist: ((String) -> Bool) = { key in
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func numberAdd(myCharacter: String) {
        numberStore += myCharacter
        lblPhoneNumber.setText(numberStore)
    }
    func clearItems() {
        numberStore = String()
        recipNameString = String()
        lblName.setText("Contact Name")
        lblPhoneNumber.setText("")
    }
    
    //Mark: Keypad that addes numbers to phone number
    @IBAction func appendNumber1(){
        numberAdd(myCharacter: "1")
    }
    @IBAction func appendNumber2() {
        numberAdd(myCharacter: "2")
    }
    @IBAction func appendNumber3() {
        numberAdd(myCharacter: "3")
    }
    @IBAction func appendNumber4() {
        numberAdd(myCharacter: "4")
    }
    @IBAction func appendNumber5() {
        numberAdd(myCharacter: "5")
    }
    @IBAction func appendNumber6() {
        numberAdd(myCharacter: "6")
    }
    @IBAction func appendNumber7() {
        numberAdd(myCharacter: "7")
    }
    @IBAction func appendNumber8() {
        numberAdd(myCharacter: "8")
    }
    @IBAction func appendNumber9() {
        numberAdd(myCharacter: "9")
    }
    @IBAction func appendNumber0() {
        numberAdd(myCharacter: "0")
    }
    @IBAction func removeLastNumber() {
        guard !numberStore.isEmpty else { return }
        numberStore.remove(at: numberStore.index(before: numberStore.endIndex))
        lblPhoneNumber.setText("\(numberStore)")
    }
    
    // MARK: - Force Push button resets all
    @IBAction func clearAll() {
        clearItems()
    }
    
    // MARK: - Add name to RecipNameStrings
    @IBAction func addNewContact() {
        presentTextInputController(withSuggestions: ["New Contact"], allowedInputMode: WKTextInputMode.plain) { (name) in
            guard let name = name else {return}
            let nameString = name[0] as! String
            self.recipNameString = nameString
            self.lblName.setText(nameString)
        }
    }
    
    
    
    //  MARK: Send user info to iPhone. If either name or number are blank, do nothing.
    @IBAction func sendtoPhone() {
        guard !recipNameString.isEmpty || !numberStore.isEmpty else { return }
        
        // TODO: - Add in a notification that states one of these is blank.
        
        if WCSession.default.isReachable {
             if checkIfUserDefaultExist("SavedContacts") {
                loadStoredContacts()
            }
            sendContactsToPhone()
            DispatchQueue.main.async {
                self.notifyUserAfterSave(inRange: true,
                                         UUID: UUID().uuidString,
                                         contactName: self.recipNameString)
            }
        } else {
            //   If WCSession isn't reachable, store contact on watch until phone is reachable.
            storeSavedContacts()
            DispatchQueue.main.async {
                self.notifyUserAfterSave(inRange: false,
                                         UUID: UUID().uuidString,
                                         contactName: self.recipNameString)
            }
        }
        // Reset Strings for next contact upload
        self.clearItems()
    }
    
    // MARK: Sends data to phone
    func sendContactsToPhone() {
        let location = getLocation()
        let contactData = Contacts.init(name: recipNameString,
                                        phoneNumber: numberStore,
                                        latitude: location.0,
                                        longitude: location.1,
                                        date: location.2)
        contacts.append(contactData)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(contacts)
        WCSession.default.sendMessageData(data, replyHandler: { _ in },
                                          errorHandler: nil)
        contacts = []
    }
    
    // MARK: - Store Contacts
    func storeSavedContacts() {
        // Load contacts if UserDefaults exist
        if checkIfUserDefaultExist("SavedContacts") {
                      loadStoredContacts()
        }
        // Create contact to be stored
        let location = getLocation()
        let contactData = Contacts.init(name: recipNameString,
                                        phoneNumber: numberStore,
                                        latitude: location.0,
                                        longitude: location.1,
                                        date: location.2)
        // Append contact to array
        contacts.append(contactData)
        // Encode array and store into User Defaults
        let encoder = JSONEncoder()
        let data = try! encoder.encode(contacts)
        contactsDefault.set(data, forKey: "SavedContacts")
        // clear contact array.
        contacts = []
    }
    
    // MARK: upload contacts stored temporarily
    func loadStoredContacts() {
        let data = contactsDefault.object(forKey: "SavedContacts") as! Data
        guard let decodedData = try? JSONDecoder().decode([Contacts].self,
                                                          from: data) else { return }
        contacts.append(contentsOf: decodedData)
        contactsDefault.removeObject(forKey: "SavedContacts")
    }
}


