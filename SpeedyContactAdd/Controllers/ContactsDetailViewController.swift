//
//  ContactsDetailViewController.swift
//  SpeedyContactAdd
//
//  Created by Joe on 5/1/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ContactsDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateAddedTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var contact: Contacts?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Action Items
    func updateViews() {
        guard let contact = contact else {return}
        let theDate = dateFormatter.string(from: contact.date)
        nameTextField.text = contact.name
        phoneTextField.text = contact.phoneNumber
        dateAddedTextField.text = theDate
        let location = CLLocation(latitude: contact.latitude, longitude: contact.longitude)
        mapView.centerToLocation(location)
    }
    
}


