//
//  MonitorBeaconsViewController.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import CoreLocation

class MonitorBeaconsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var monitorEvents: [MonitorEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.monitorEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let monitorEvent = self.monitorEvents[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MonitorEventTableCell")!
        let uuidLabel = cell.viewWithTag(10) as! UILabel
        uuidLabel.text = monitorEvent.beaconRegion.proximityUUID.uuidString
        
        let majorLabel = cell.viewWithTag(20) as! UILabel
        if let majorValue = monitorEvent.beaconRegion.major {
            majorLabel.text = String(describing: majorValue)
        }
    
        let minorLabel = cell.viewWithTag(30) as! UILabel
        if let minorValue = monitorEvent.beaconRegion.minor {
            minorLabel.text = String(describing: minorValue)
        }
        
        let typeLabel = cell.viewWithTag(40) as! UILabel
        typeLabel.text = monitorEvent.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

class MonitorEvent {
    let beaconRegion: CLBeaconRegion
    let description: String
    
    init(beaconRegion: CLBeaconRegion, description: String) {
        self.beaconRegion = beaconRegion
        self.description = description
    }
}
