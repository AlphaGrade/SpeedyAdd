//
//  NotificationController.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
     override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        completionHandler(.custom)
     }
    
    
    
}
// MARK: - notifies user that data has either been sent to phone or is in Queue until phone reconnects to phone
extension InterfaceController {
    
    
    func UserNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func stringWithUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)!
        return uuidString as String
    }
    
    
    
    func notifyUserAfterSave(inRange: Bool, UUID: String, contactName: String )  {
        // If WCSession is reachable, we notify stating contact has been sent to iOS
        if  inRange == true {
            let content = UNMutableNotificationContent()
            content.title = "Contact Added!"
            content.body = "\(contactName) has been added to your list"
            content.badge = 1
            content.sound = UNNotificationSound.default() // Deliver the notification in one second.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Date().timeIntervalSinceNow + 1, repeats: false)
            
            let identifier = UUID
            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
            // Schedule the notification.
            
            // optionally clear out pending and delivered notifications before adding new request
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            
            // If WCSession isn't reachable, Contact Will be stored on Watch until session is active.
        } else if inRange == false {
            let content = UNMutableNotificationContent()
            content.title = "Contact Pending."
            content.body = "\(contactName) will be added when your watch reconnects to your iPhone."
            content.badge = 1
            content.sound = UNNotificationSound.default() // Deliver the notification in one second.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Date().timeIntervalSinceNow + 1, repeats: false)
            
            let identifier = UUID
            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
            // Schedule the notification.
            
            // optionally clear out pending and delivered notifications before adding new request
            let center = UNUserNotificationCenter.current()
            
            center.add(request, withCompletionHandler: nil)
        }
    }
}
