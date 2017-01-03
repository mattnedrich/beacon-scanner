//
//  IBeaconsHolder.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconsHolder: NSObject {
  
    var beaconInfos: [BeaconInfo] = BeaconsHolder.getDefaultBeacons()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(BeaconsHolder.addIBeacon), name: NSNotification.Name(rawValue: "NewIBeacon"), object: nil)
    }
    
    func addIBeacon(notification: NSNotification) {
        if let beaconRegion = notification.userInfo?["beaconRegion"] as? CLBeaconRegion {
            self.beaconInfos.append(BeaconInfo(beaconRegion: beaconRegion))
            let data = ["beacons": self.beaconInfos]
            NotificationCenter.default.post(name: Notification.Name("BeaconsUpdated"), object: nil, userInfo: data)
        }
    }
    
    func removeIBeacon() {
        // TODO
    }
    
    static func getDefaultBeacons() -> [BeaconInfo] {
        return [
            BeaconInfo(beaconRegion: CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! , major: 24780, minor: 5258, identifier: "Estimote")),
            BeaconInfo(beaconRegion: CLBeaconRegion(proximityUUID: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")! , major: 0, minor: 1, identifier: "RadNetworks1")),
            BeaconInfo(beaconRegion: CLBeaconRegion(proximityUUID: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")! , major: 0, minor: 2, identifier: "RadNetworks2")),
        ]
    }
}

class BeaconInfo {
    
    let beaconRegion: CLBeaconRegion
    let shouldMonitor: Bool = false
   
    private var _shouldRange: Bool = false
    var shouldRange: Bool {
        get { return self._shouldRange }
        set {
            self._shouldRange = newValue
            if newValue {
                self.range()
            } else {
                self.stopRange()
            }
        }
    }
   
    init(beaconRegion: CLBeaconRegion) {
        self.beaconRegion = beaconRegion
    }
   
    func range() {
        let data = ["beacon": self]
        NotificationCenter.default.post(name: Notification.Name("StartRangingNotification"), object: nil, userInfo: data)
    }
    
    func stopRange() {
        let data = ["beacon": self]
        NotificationCenter.default.post(name: Notification.Name("StopRangingNotification"), object: nil, userInfo: data)
    }
    
    func monitor() {
        let data = ["beacon": self]
        NotificationCenter.default.post(name: Notification.Name("MonitoringEnabled"), object: nil, userInfo: data)
    }
    
    func stopMonitor() {
        let data = ["beacon": self]
        NotificationCenter.default.post(name: Notification.Name("MonitoringDisabled"), object: nil, userInfo: data)
    }

    func stopAll() {
        stopRange()
        stopMonitor()
    }
    
}
