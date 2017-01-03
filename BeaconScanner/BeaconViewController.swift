//
//  IBeaconViewController.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconViewController: UIViewController, UITableViewDataSource {

    var beacons: [CLBeaconRegion] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.beacons = appDelegate.beaconsHolder.beaconInfos.map({ (beaconInfo) -> CLBeaconRegion in
            return beaconInfo.beaconRegion
        })
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(BeaconViewController.beaconsUpdated), name: NSNotification.Name(rawValue: "BeaconsUpdated"), object: nil)
    }
    
    func beaconsUpdated(notification: NSNotification) {
        if let beaconInfos = notification.userInfo?["beacons"] as? [BeaconInfo] {
            self.beacons = beaconInfos.map({ (beaconInfo) -> CLBeaconRegion in
                return beaconInfo.beaconRegion
            })
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beacon = self.beacons[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "iBeaconCell")!
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
        
        return cell
    }

}
