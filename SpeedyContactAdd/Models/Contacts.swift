//
//  Contacts.swift
//  SpeedyContactAdd
//
//  Created by Joe on 5/7/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation

struct Contacts: Codable {
    let name: String
    let phoneNumber: String
    let longitude: Double
    let latitude: Double
    let date: String
}
