//
//  Contacts.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron on 11/10/18.
//  Copyright © 2018 AlphaGradeINC. All rights reserved.
//

import Foundation

struct Contacts: Codable {
    let name: String
    let phoneNumber: String
    let latitude: Double
    let longitude: Double
    let date: Date
}

