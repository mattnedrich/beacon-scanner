//
//  BeaconRanger.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import CoreLocation

class BeaconRanger: NSObject, CLLocationManagerDelegate {
   
    let locationManager: CLLocationManager
    var beaconsToRange: [CLBeaconRegion] = []
    
    override init() {
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        super.init()
        locationManager.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(BeaconRanger.startRangingNotification), name: NSNotification.Name(rawValue: "StartRangingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BeaconRanger.stopRangingNotification), name: NSNotification.Name(rawValue: "StopRangingNotification"), object: nil)
    }
   
    func startRangingNotification(notification: NSNotification) {
        if let beaconInfo = notification.userInfo?["beacon"] as? BeaconInfo {
            self.startRangingBeacon(beaconRegion: beaconInfo.beaconRegion)
        }
    }

    func stopRangingNotification(notification: NSNotification) {
        if let beaconInfo = notification.userInfo?["beacon"] as? BeaconInfo {
            self.stopRangingBeacon(beaconRegion: beaconInfo.beaconRegion)
        }
    }
    
    func startRangingBeacon(beaconRegion: CLBeaconRegion) {
        self.beaconsToRange.append(beaconRegion)
        self.locationManager.startRangingBeacons(in: beaconRegion)
        print("Started ranging for \(beaconRegion.printString)")
    }
    
    func stopRangingBeacon(beaconRegion: CLBeaconRegion) {
        if let index = self.beaconsToRange.index(of: beaconRegion) {
            self.beaconsToRange.remove(at: index)
            self.locationManager.stopRangingBeacons(in: beaconRegion)
            print("Stopped ranging for \(beaconRegion.printString)")
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            var beaconProximity: String;
            switch (beacon.proximity) {
            case CLProximity.unknown:    beaconProximity = "Unknown";
            case CLProximity.far:        beaconProximity = "Far";
            case CLProximity.near:       beaconProximity = "Near";
            case CLProximity.immediate:  beaconProximity = "Immediate";
            }
            print("BEACON RANGED: uuid: \(beacon.proximityUUID.uuidString) major: \(beacon.major)  minor: \(beacon.minor) proximity: \(beaconProximity)")
           
            let rangeEvent = RangeEvent(beacon: beacon, proximity: beacon.proximity, accuracy: beacon.accuracy)
            let data = ["rangeEvent": rangeEvent]
            NotificationCenter.default.post(name: Notification.Name("BeaconRangedEvent"), object: nil, userInfo: data)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error)
    }
    
}

class RangeEvent {
    let beacon: CLBeacon
    let proximity: CLProximity
    let accuracy: CLLocationAccuracy
    
    init(beacon: CLBeacon, proximity: CLProximity, accuracy: CLLocationAccuracy) {
        self.beacon = beacon
        self.proximity = proximity
        self.accuracy = accuracy
    }
}
