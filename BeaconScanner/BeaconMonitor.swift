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

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(BeaconMonitor.startMonitoringNotification), name: NSNotification.Name(rawValue: "StartMonitoringNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BeaconMonitor.stopMonitoringNotification), name: NSNotification.Name(rawValue: "StopMonitoringNotification"), object: nil)
    }
   
    func startMonitoringNotification(notification: NSNotification) {
        if let beaconInfo = notification.userInfo?["beacon"] as? BeaconInfo {
            self.startMonitoringBeacon(beaconRegion: beaconInfo.beaconRegion)
        }
    }

    func stopMonitoringNotification(notification: NSNotification) {
        if let beaconInfo = notification.userInfo?["beacon"] as? BeaconInfo {
            self.stopMonitoringBeacon(beaconRegion: beaconInfo.beaconRegion)
        }
    }
    
    func startMonitoringBeacon(beaconRegion: CLBeaconRegion) {
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        beaconRegion.notifyEntryStateOnDisplay = true
        print("Will start monitoring \(beaconRegion.printString)")
        self.beaconsToMonitor.append(beaconRegion)
        self.locationManager.startMonitoring(for: beaconRegion)
    }
    
    func stopMonitoringBeacon(beaconRegion: CLBeaconRegion) {
        print("Will stop monitoring \(beaconRegion.printString)")
        if let index = self.beaconsToMonitor.index(of: beaconRegion) {
            self.beaconsToMonitor.remove(at: index)
            self.locationManager.stopMonitoring(for: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("Enter: \(beaconRegion.printString)")
            let monitorEvent = MonitorEvent(beacon: beaconRegion, type: MonitorEventType.Enter)
            let data = ["monitorEvent": monitorEvent]
            NotificationCenter.default.post(name: Notification.Name("BeaconMonitoredEvent"), object: nil, userInfo: data)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("Exit: \(beaconRegion.printString)")
            let monitorEvent = MonitorEvent(beacon: beaconRegion, type: MonitorEventType.Exit)
            let data = ["monitorEvent": monitorEvent]
            NotificationCenter.default.post(name: Notification.Name("BeaconMonitoredEvent"), object: nil, userInfo: data)
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

class MonitorEvent {
    let beacon: CLBeaconRegion
    let type: MonitorEventType
    
    init(beacon: CLBeaconRegion, type: MonitorEventType) {
        self.beacon = beacon
        self.type = type
    }
}
