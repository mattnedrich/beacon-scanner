//
//  ToggleBeaconsViewController.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import CoreLocation

class ToggleBeaconsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var beaconInfos: [BeaconInfo] = []
    @IBOutlet weak var tableView: UITableView!
   
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.beaconInfos = appDelegate.beaconsHolder.beaconInfos
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.beaconInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beaconInfo = self.beaconInfos[indexPath.row]
        let beacon = beaconInfo.beaconRegion
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "toggleTableViewCell")!
        let uuidLabel = cell.viewWithTag(10) as! UILabel
        uuidLabel.text = beacon.proximityUUID.uuidString
        
        let majorLabel = cell.viewWithTag(20) as! UILabel
        if let majorValue = beacon.major {
            majorLabel.text = String(describing: majorValue)
        }
    
        let minorLabel = cell.viewWithTag(30) as! UILabel
        if let minorValue = beacon.minor {
            minorLabel.text = String(describing: minorValue)
        }
        
        let stateLabel = cell.viewWithTag(40) as! UILabel
        stateLabel.text = beaconInfo.shouldRange ? "Enabled" : "Disabled"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beaconInfo = self.beaconInfos[indexPath.row]
        beaconInfo.shouldRange = !beaconInfo.shouldRange
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

class BeaconState {
    var enabled: Bool = false
    let beacon: CLBeaconRegion
    
    init(beacon: CLBeaconRegion) {
        self.beacon = beacon
    }
}
