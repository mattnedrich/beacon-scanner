//
//  RangeBeaconsViewController.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import CoreLocation

class RangeBeaconsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var rangeEvents: [RangeEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(RangeBeaconsViewController.rangeEvent), name: NSNotification.Name(rawValue: "BeaconRangedEvent"), object: nil)
    }
   
    func rangeEvent(notification: NSNotification) {
        if let rangeEvent = notification.userInfo?["rangeEvent"] as? RangeEvent {
            self.rangeEvents.append(rangeEvent)
            self.tableView.reloadData()
            
            let indexPath = IndexPath(row: self.rangeEvents.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rangeEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rangeEvent = self.rangeEvents[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RangeEventTableCell")!
        let uuidLabel = cell.viewWithTag(10) as! UILabel
        uuidLabel.text = rangeEvent.beacon.proximityUUID.uuidString
        
        let majorLabel = cell.viewWithTag(20) as! UILabel
        majorLabel.text = String(describing: rangeEvent.beacon.major)
    
        let minorLabel = cell.viewWithTag(30) as! UILabel
        minorLabel.text = String(describing: rangeEvent.beacon.minor)
        
        let proximityLabel = cell.viewWithTag(40) as! UILabel
        proximityLabel.text = rangeEvent.proximity.printString
        
        let accuracyLabel = cell.viewWithTag(50) as! UILabel
        accuracyLabel.text = String(rangeEvent.accuracy)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    @IBAction func configureBeaconsAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let beaconTuples = appDelegate.beaconsHolder.beaconInfos.map { (beaconInfo: BeaconInfo) -> (CLBeaconRegion, ToggleBeaconOperation) in
            let toggleOp: () -> () = {beaconInfo.shouldRange = !beaconInfo.shouldRange}
            let currentStateOp: () -> Bool = {return beaconInfo.shouldRange}
            return (beaconInfo.beaconRegion, ToggleBeaconOperation(toggle: toggleOp, currentState: currentStateOp))
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ToggleBeaconsViewController") as! ToggleBeaconsViewController
        controller.beaconInfos = beaconTuples
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

