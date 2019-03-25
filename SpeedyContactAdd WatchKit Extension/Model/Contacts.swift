//
//  Contacts.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron on 11/10/18.
//  Copyright © 2018 AlphaGradeINC. All rights reserved.
//

import UIKit

extension InterfaceController {
struct Contacts {
    let name: String
    let phoneNumber: Any
    
    func convertToDictionary() -> [String:Any] {
        
    let contactToSend = ["RecipientName":name, "PhoneNumber":phoneNumber]
        return contactToSend
        
        }
    }
}
