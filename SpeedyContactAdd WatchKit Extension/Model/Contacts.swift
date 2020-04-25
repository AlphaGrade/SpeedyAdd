//
//  Contacts.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron on 11/10/18.
//  Copyright © 2018 AlphaGradeINC. All rights reserved.
//

import UIKit

struct Contacts {
    let name: String
    let phoneNumber: Any
    let longitude: String
    let latitude: String
    let date: Date
    
    func convertToDictionary() -> [String:Any] {
        
        let contactToSend = ["recipientName":name,
                             "phoneNumber":phoneNumber,
                             "longitude":longitude,
                             "latitude":latitude, "date":date ]
        
        return contactToSend
        
        }
    }

