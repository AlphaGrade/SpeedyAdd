//
//  InterfaceController.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//

import WatchKit
import UIKit
import WatchConnectivity
import CoreLocation

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if(WCSession.isSupported()){
            self.session = WCSession.default
            session.delegate = self
            self.session.activate()
        }
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    @IBOutlet var lblPhoneNumber: WKInterfaceLabel!
    @IBOutlet weak var lblReName: WKInterfaceLabel!
    
    var session:WCSession!
    var contacts: [Contacts] = []
    var numberStore = String()
    var recipNameString = String()
    var identifierInt : Int = 1
    var contactTempStore : [String:String] = [:]
    var fullNameString = "fullNameString"
    var numberString = "numberString"
    var timer = Timer()
    let contactsDefault = UserDefaults.standard
    
    func numberAdd(myCharacter:String) {
        numberStore += myCharacter
        lblPhoneNumber.setText(numberStore)
    }
    func clearItems() {
        numberStore = ""
        recipNameString = ""
        lblReName.setText("Contact Name")
        lblPhoneNumber.setText("")
    }
    
    //Mark: Keypad that addes numbers to phone number
    @IBAction func btnNumber1Action(){
        numberAdd(myCharacter: "1")
    }
    @IBAction func btnNumber2Action() {
        numberAdd(myCharacter: "2")
    }
    @IBAction func btnNumber3Action() {
        numberAdd(myCharacter: "3")
    }
    @IBAction func btnNumber4Action() {
        numberAdd(myCharacter: "4")
    }
    @IBAction func btnNumber5Action() {
        numberAdd(myCharacter: "5")
    }
    @IBAction func btnNumber6Action() {
        numberAdd(myCharacter: "6")
    }
    @IBAction func btnNumber7Action() {
        numberAdd(myCharacter: "7")
    }
    @IBAction func btnNumber8Action() {
        numberAdd(myCharacter: "8")
    }
    @IBAction func btnNumber9Action() {
        numberAdd(myCharacter: "9")
    }
    @IBAction func btnNumber0Action() {
        numberAdd(myCharacter: "0")
    }
    @IBAction func btnBackspaceAction() {
        if numberStore != "" {
            numberStore.remove(at: numberStore.index(before: numberStore.endIndex))
            lblPhoneNumber.setText("\(numberStore)")
        } else {return}
    }
    // MARK: - Force Push button resets all
    @IBAction func btnMenuClear() {
        clearItems()
    }
    
    // MARK: - Add name to RecipNameStrings
    @IBAction func btnAddNameAction() {
        presentTextInputController(withSuggestions: ["New Contact"], allowedInputMode: WKTextInputMode.plain) { (result) in
            guard let result = result else {return}
            let resultString = result[0] as! String
            self.recipNameString = resultString
            self.lblReName.setText("\(resultString)")
        }
    }
    
    
    
    //  MARK: Send user info to iPhone. If either name or number are blank, do nothing.
    @IBAction func btnSendtoPhone() {
        
        if recipNameString == "" || numberStore == "" {return}
        
        // TODO: - Add in a notification that states one of these is blank.
        
        if (WCSession.default.isReachable) {
            sendContactsToPhone()
            DispatchQueue.main.async {
                self.notifyUserAfterSave(inRange: true,
                                         UUID: UUID().uuidString,
                                         contactName: self.recipNameString)
            }
        } else {
            //   If WCSession isn't reachable, store contact on watch until phone is reachable.
            uploadStoredContacts()
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
    let data = (try? encoder.encode(contacts))!
    WCSession.default.sendMessageData(data, replyHandler: { Data in
    }, errorHandler: nil)
    contacts = []
}
// MARK: Store Contacts
func storeSavedContacts() {
    let location = getLocation()
    let contactData = Contacts.init(name: recipNameString,
                                    phoneNumber: numberStore,
                                    latitude: location.0,
                                    longitude: location.1,
                                    date: location.2)
    contacts.append(contactData)
    let encoder = JSONEncoder()
    let data = (try? encoder.encode(contacts))!
    contactsDefault.set(data, forKey: "SavedContacts")
}

// MARK: upload contacts stored temporarily
func uploadStoredContacts() {
    let encoder = JSONEncoder()
    let data = (try? encoder.encode(contacts))!
    WCSession.default.sendMessageData(data, replyHandler: { Data in
    }, errorHandler: nil)
    contacts = []
}
}


