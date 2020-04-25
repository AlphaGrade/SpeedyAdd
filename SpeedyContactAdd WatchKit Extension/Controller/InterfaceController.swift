//
//  InterfaceController.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UIKit
import MapKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
   var session:WCSession!
    
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
    
    @IBOutlet var lblPhoneNumber: WKInterfaceLabel!
    @IBOutlet weak var lblReName: WKInterfaceLabel!
    
    
    var NumberStore = String()
    var RecipNameString = String() 
    var identifierInt : Int = 1
    var contactTempStore : [String:String] = [:]
    var fullNameString = "fullNameString"
    var numberString = "numberString"
    var timer = Timer()
    
    func numberAdd(myCharacter:String) {
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    func clearItems() {
        NumberStore = ""
        RecipNameString = ""
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
        if NumberStore != "" {
        NumberStore.remove(at: NumberStore.index(before: NumberStore.endIndex))
        lblPhoneNumber.setText("\(NumberStore)")
        } else {return}
    }
    // MARK: - Force Push button resets all
    @IBAction func btnMenuClear() {
            clearItems()
    }
    
    // MARK: add name to RecipNameStrings
    @IBAction func btnAddNameAction() {
        presentTextInputController(withSuggestions: ["New Contact"], allowedInputMode: WKTextInputMode.plain) { (result) in
            guard let result = result else {return}
            let resultString = result[0] as! String
            self.RecipNameString = resultString
            self.lblReName.setText("\(resultString)")
        }
    }
    
    //Creates a queue for stored contacts
    func tempStoreUniqueKeyGen() {
        
        fullNameString += "\(identifierInt)"
        numberString += "\(identifierInt)"
        
        identifierInt = identifierInt &+ 1
        print("\(identifierInt)")
        print("\(fullNameString)")
        
    }
    
    //  MARK: Send user info to iPhone. If either name or number are blank, do nothing.
    @IBAction func btnSendtoPhone() {
        
        if RecipNameString == "" || NumberStore == "" {return}
        
    // TODO: - Add in a notification that states one of these is blank.

        if (WCSession.default.isReachable) {

            let message = Contacts.init(name: RecipNameString, phoneNumber: NumberStore).convertToDictionary()
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)

        } else {
//   If WCSession isn't reachable, store contact on watch until phone is reachable.
            tempStoreUniqueKeyGen()
                contactTempStore["\(fullNameString)"] = RecipNameString
                contactTempStore["\(numberString)"] = NumberStore
                fullNameString = "fullNameString"
                numberString = "numberString"
                print ("\(contactTempStore)")
                print("Session is not Reachable")
                uploadTempContacts()
            
            }
    // Notify User that Data was Sent (Or if out of Range state it will be uploaded when in range of iPhone)
        DispatchQueue.main.async {
                if (WCSession.default.isReachable) {
                    self.notifyUserAfterSave(inRange: true, UUID: self.stringWithUUID(), contactName: self.RecipNameString)
                } else if (!WCSession.default.isReachable){
                    self.notifyUserAfterSave(inRange: false, UUID: self.stringWithUUID(), contactName: self.RecipNameString)
                }
                // MARK: Reset Strings for next contact upload
            self.clearItems()
        }
    
    }

        // MARK: upload contacts stored temporarily
    @objc func uploadTempContacts() {
        if (WCSession.default.isReachable) && contactTempStore != [:] {
            
            WCSession.default.sendMessage(contactTempStore, replyHandler: nil, errorHandler: nil)
            
            timer.invalidate()
            
        } else {
            
            timer = Timer.scheduledTimer(timeInterval: 150, target: self, selector: #selector(InterfaceController.uploadTempContacts), userInfo: nil, repeats: true)
            
        }
    }
}
