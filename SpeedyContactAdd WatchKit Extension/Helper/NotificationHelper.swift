//
//  NotificationHelper.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Joe on 6/8/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//
import Foundation
import UserNotifications

// MARK: - notifies user that data has either been sent to phone or is in Queue until phone reconnects to phone
extension InterfaceController {

    func UserNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func notifyUserAfterSave(inRange: Bool, UUID: String, contactName: String)  {
        // If WCSession is reachable, we notify stating contact has been sent to iOS
        if  inRange == true {
            runNote(UUID: UUID,
                    contactName: contactName,
                    message: "Contact Added!",
                    body: "\(contactName) has been added to your list.")
            // If WCSession isn't reachable, Contact Will be stored on Watch until session is active.
        } else if inRange == false {
            runNote(UUID: UUID,
                    contactName: contactName,
                    message: "Contact Pending.",
                    body: "\(contactName) will be added when your watch reconnects to your iPhone.")
        }
    }
    
    func runNote(UUID: String, contactName: String, message: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = message
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default // Deliver the notification in one second.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Date().timeIntervalSinceNow + 1, repeats: false)
        
        let identifier = UUID
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        // Schedule the notification.
        // optionally clear out pending and delivered notifications before adding new request
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: nil)
    }
}
