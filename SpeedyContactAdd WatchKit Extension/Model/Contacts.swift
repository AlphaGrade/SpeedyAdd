//
//  Contacts.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron on 11/10/18.
//  Copyright © 2018 AlphaGradeINC. All rights reserved.
//

import UIKit

struct Contacts {
    let id: Any
    let name: String
    let phoneNumber: String
    let longitude: Double
    let latitude: Double
    let date: Date
    
    func convertToDictionary() -> [String:Any] {
        
        let contactToSend = ["recipientName":name,
                             "phoneNumber":phoneNumber,
                             "longitude":longitude,
                             "latitude":latitude, "date":date, "id":id ]
        
        return contactToSend
        
    }
    
//    func convertToData() -> Data {
//        
//    }
}

