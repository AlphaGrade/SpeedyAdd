//
//  InterfaceController.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit
import UserNotifications

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
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
        
        
    }
    
    @IBOutlet var lblPhoneNumber: WKInterfaceLabel!
    @IBOutlet var lblRecipName: WKInterfaceLabel!
    
    
    var NumberStore = String()
    var RecipNameString = String()
    var transfer = ""
    var identifierInt : Int = 1
    var plusOneInt: Int = 1
    var contactTempStore : [String:String] = [:]
    var fullNameString = "fullNameString"
    var numberString = "numberString"
    var timer = Timer()
    
    //Mark: Keypad that addes numbers to phone number
    @IBAction func btnNumber1Action(){
        let myCharacter = "1"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    
    @IBAction func btnNumber2Action() {
        let myCharacter = "2"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    @IBAction func btnNumber3Action() {
        let myCharacter = "3"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    @IBAction func btnNumber4Action() {
        let myCharacter = "4"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    @IBAction func btnNumber5Action() {
        let myCharacter = "5"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    @IBAction func btnNumber6Action() {
        let myCharacter = "6"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)    }
    @IBAction func btnNumber7Action() {
        let myCharacter = "7"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    @IBAction func btnNumber8Action() {
        let myCharacter = "8"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)    }
    @IBAction func btnNumber9Action() {
        let myCharacter = "9"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)
    }
    @IBAction func btnNumber0Action() {
        let myCharacter = "0"
        NumberStore += myCharacter
        lblPhoneNumber.setText(NumberStore)    }
    @IBAction func btnBackspaceAction() {
        NumberStore.remove(at: NumberStore.index(before: NumberStore.endIndex))
        lblPhoneNumber.setText("\(NumberStore)")
    }
    // MARK: Force Push button resets all
    @IBAction func btnMenuClear() {
        
       
            NumberStore = ""
            RecipNameString = ""
            lblRecipName.setText("Contact Name")
            lblPhoneNumber.setText("")
        
    }
    
    // MARK: add name to RecipNameStrings
    @IBAction func btnAddNameAction() {
      
        presentTextInputController(withSuggestions: ["New Contact"],allowedInputMode:WKTextInputMode.plain, completion:  {(result) -> Void in
            if ((result != nil) && (result!.count>0) ){
            let resultString = result![0] as! String
            self.lblRecipName.setText(resultString)
            self.RecipNameString = resultString
            }
         })
      }
    
   //Creates a queue
    func tempStoreUniqueKeyGen() {
        
        fullNameString += "\(identifierInt)"
        numberString += "\(identifierInt)"
        
        identifierInt = identifierInt &+ 1
        print("\(identifierInt)")
        print("\(fullNameString)")
        
    }
    
    //  MARK: Send user info to iPhone
    
    @IBAction func btnSendtoPhone() {
        
        if RecipNameString == "" {return}
        if NumberStore == "" {return}
        
        if (WCSession.default.isReachable) {
            
       
          let message = ["RecipientName":RecipNameString, "PhoneNumber":NumberStore]
            
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
    func UserNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }
   
       func stringWithUUID() -> String {
            let uuidObj = CFUUIDCreate(nil)
            let uuidString = CFUUIDCreateString(nil, uuidObj)!
            return uuidString as String
        }
// If WCSession is reachable, we notify stating contact has been sent to iOS
    if (WCSession.default.isReachable) {
        let content = UNMutableNotificationContent()
        content.title = "Contact Added!"
        content.body = "\(RecipNameString) has been added to your list"
        content.badge = 1
        content.sound = UNNotificationSound.default() // Deliver the notification in one second.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Date().timeIntervalSinceNow + 1, repeats: false)
            
        let identifier = stringWithUUID()
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        // Schedule the notification.
        
        // optionally clear out pending and delivered notifications before adding new request
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        
// If WCSession isn't reachable, Contact Will be stored on Watch until session is active.
      } else {
        let content = UNMutableNotificationContent()
        content.title = "Contact Pending."
        content.body = "\(RecipNameString) will be added when your watch reconnects to your iPhone."
        content.badge = 1
        content.sound = UNNotificationSound.default() // Deliver the notification in one second.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Date().timeIntervalSinceNow + 1, repeats: false)
        
        let identifier = stringWithUUID()
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        // Schedule the notification.
        
        // optionally clear out pending and delivered notifications before adding new request
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: nil)
        }

        // MARK: Reset Strings for next contact upload
        NumberStore = ""
        RecipNameString = ""
        lblRecipName.setText("Contact Name")
        lblPhoneNumber.setText("")
        
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

