//
//  BeaconMonitor.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconMonitor: NSObject, CLLocationManagerDelegate {
   
    let locationManager: CLLocationManager
    var beaconsToMonitor: [CLBeaconRegion] = []
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    func startMonitoringBeacon(beaconRegion: CLBeaconRegion) {
        self.beaconsToMonitor.append(beaconRegion)
        self.locationManager.startMonitoring(for: beaconRegion)
    }
    
    func stopMonitoringBeacon(beaconRegion: CLBeaconRegion) {
        if let index = self.beaconsToMonitor.index(of: beaconRegion) {
            self.beaconsToMonitor.remove(at: index)
            self.locationManager.stopMonitoring(for: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did Enter Region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Did Exit Region")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started Monitoring Successfully")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Error monitoring: \(error.localizedDescription)")
    }
    
}
