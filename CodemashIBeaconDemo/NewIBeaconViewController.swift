//
//  NewIBeaconViewController.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import CoreLocation

class NewIBeaconViewController: UIViewController {

    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func saveAction(_ sender: Any) {
        let uuidString = self.uuidTextField.text!
        let majorString = self.majorTextField.text!
        let minorString = self.minorTextField.text!
        let identifier = uuidString + majorString + minorString
        
        if let uuid = UUID(uuidString: uuidString) {
            if let minor = UInt16(minorString), let major = UInt16(majorString) {
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
                let data = ["beaconRegion": beaconRegion]
                NotificationCenter.default.post(name: Notification.Name("NewIBeacon"), object: nil, userInfo: data)
            } else if let major = UInt16(majorString) {
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, identifier: identifier)
                let data = ["beaconRegion": beaconRegion]
                NotificationCenter.default.post(name: Notification.Name("NewIBeacon"), object: nil, userInfo: data)
            } else {
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
                let data = ["beaconRegion": beaconRegion]
                NotificationCenter.default.post(name: Notification.Name("NewIBeacon"), object: nil, userInfo: data)
            }
        } else {
            print("could not create uuid")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
