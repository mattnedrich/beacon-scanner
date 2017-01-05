//
//  ToggleBeaconsViewController.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import CoreLocation

class ToggleBeaconOperation {
    var toggle: () -> ()
    var currentState: () -> Bool
    
    init(toggle: @escaping () -> (), currentState: @escaping () -> Bool) {
        self.toggle = toggle
        self.currentState = currentState
    }
}

class ToggleBeaconsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var beaconInfos: [(beacon: CLBeaconRegion, toggleOperation: ToggleBeaconOperation)] = []
    @IBOutlet weak var tableView: UITableView!
   
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        self.beaconInfos = appDelegate.beaconsHolder.beaconInfos
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.beaconInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beaconTuple = self.beaconInfos[indexPath.row]
        let beacon = beaconTuple.beacon
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
        let stateView = cell.viewWithTag(50)!
        stateView.layer.cornerRadius = 4
       
        if beaconTuple.toggleOperation.currentState() {
            stateView.backgroundColor = UIColor.blue
            stateLabel.text = "Enabled"
        } else {
            stateView.backgroundColor = UIColor(red: (195/255), green: (195/255), blue: (195/255), alpha: 1.0)
            stateLabel.text = "Disabled"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.beaconInfos[indexPath.row].toggleOperation.toggle()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

