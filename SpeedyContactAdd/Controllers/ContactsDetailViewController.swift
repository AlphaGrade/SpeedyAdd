//
//  ContactsDetailViewController.swift
//  SpeedyContactAdd
//
//  Created by Joe on 5/1/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import MapKit

class ContactsDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateAddedTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var contact: Contacts?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Action Items
    func updateViews() {
        guard let contact = contact else {return}
        nameTextField.text = contact.name
        phoneTextField.text = contact.phoneNumber
        dateAddedTextField.text = contact.date
        let initialLocation = CLLocation(latitude: contact.latitude, longitude: contact.longitude)
        mapView.centerToLocation(initialLocation)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


