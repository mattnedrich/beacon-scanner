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

        self.locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(BeaconMonitor.startMonitoringNotification), name: NSNotification.Name(rawValue: "StartMonitoringNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BeaconMonitor.stopMonitoringNotification), name: NSNotification.Name(rawValue: "StopMonitoringNotification"), object: nil)
        
        let foo = self.locationManager.monitoredRegions
        for f in foo {
            self.locationManager.stopMonitoring(for: f)
        }
    }
   
    @objc func startMonitoringNotification(notification: NSNotification) {
        if let beaconInfo = notification.userInfo?["beacon"] as? BeaconInfo {
            self.startMonitoringBeacon(beaconRegion: beaconInfo.beaconRegion)
        }
    }

    @objc func stopMonitoringNotification(notification: NSNotification) {
        if let beaconInfo = notification.userInfo?["beacon"] as? BeaconInfo {
            self.stopMonitoringBeacon(beaconRegion: beaconInfo.beaconRegion)
        }
    }
    
    func startMonitoringBeacon(beaconRegion: CLBeaconRegion) {
        self.beaconsToMonitor.append(beaconRegion)
        self.locationManager.startMonitoring(for: beaconRegion)
        print("Will start monitoring \(beaconRegion.printString)")
    }
    
    func stopMonitoringBeacon(beaconRegion: CLBeaconRegion) {
        if let index = self.beaconsToMonitor.firstIndex(of: beaconRegion) {
            self.beaconsToMonitor.remove(at: index)
            self.locationManager.stopMonitoring(for: beaconRegion)
        }
        print("Will stop monitoring \(beaconRegion.printString)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            let monitorEvent = MonitorEvent(beacon: beaconRegion, type: MonitorEventType.Enter)
            let data = ["monitorEvent": monitorEvent]
            NotificationCenter.default.post(name: Notification.Name("BeaconMonitoredEvent"), object: nil, userInfo: data)
            print("Enter: \(beaconRegion.printString)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            let monitorEvent = MonitorEvent(beacon: beaconRegion, type: MonitorEventType.Exit)
            let data = ["monitorEvent": monitorEvent]
            NotificationCenter.default.post(name: Notification.Name("BeaconMonitoredEvent"), object: nil, userInfo: data)
            print("Exit: \(beaconRegion.printString)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started Monitoring Successfully!")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Error monitoring: \(error.localizedDescription)")
    }
    
}

enum MonitorEventType: String {
    case Enter = "Enter"
    case Exit = "Exit"
}
