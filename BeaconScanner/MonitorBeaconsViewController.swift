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
        NotificationCenter.default.addObserver(self, selector: #selector(MonitorBeaconsViewController.monitorEvent), name: NSNotification.Name(rawValue: "BeaconMonitoredEvent"), object: nil)
    }
   
    func monitorEvent(notification: NSNotification) {
        if let monitorEvent = notification.userInfo?["monitorEvent"] as? MonitorEvent {
            self.monitorEvents.append(monitorEvent)
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.monitorEvents.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.monitorEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let monitorEvent = self.monitorEvents[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MonitorEventTableCell")!
        let uuidLabel = cell.viewWithTag(10) as! UILabel
        uuidLabel.text = "UUID: \(monitorEvent.beacon.proximityUUID.uuidString)"
        
        let majorLabel = cell.viewWithTag(20) as! UILabel
        if let majorValue = monitorEvent.beacon.major {
            majorLabel.text = "Major: \(String(describing: majorValue))"
        } else {
            majorLabel.text = "Major: none"
        }
    
        let minorLabel = cell.viewWithTag(30) as! UILabel
        if let minorValue = monitorEvent.beacon.minor {
            minorLabel.text = "Minor: \(String(describing: minorValue))"
        } else {
            minorLabel.text = "Minor: none"
        }
        
        let typeLabel = cell.viewWithTag(40) as! UILabel
        typeLabel.text = monitorEvent.type.rawValue
        
        let eventView = cell.viewWithTag(50)!
        eventView.layer.cornerRadius = 4
        if monitorEvent.type == MonitorEventType.Enter {
            eventView.backgroundColor = UIColor(red: (88/255), green: (166/255), blue: (79/255), alpha: 1.0)
        } else {
            eventView.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    @IBAction func configureBeaconsAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let beaconTuples = appDelegate.beaconsHolder.beaconInfos.map { (beaconInfo: BeaconInfo) -> (CLBeaconRegion, ToggleBeaconOperation) in
            let toggleOp: () -> () = {beaconInfo.shouldMonitor = !beaconInfo.shouldMonitor}
            let currentStateOp: () -> Bool = {return beaconInfo.shouldMonitor}
            return (beaconInfo.beaconRegion, ToggleBeaconOperation(toggle: toggleOp, currentState: currentStateOp))
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ToggleBeaconsViewController") as! ToggleBeaconsViewController
        controller.beaconInfos = beaconTuples
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

