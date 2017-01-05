//
//  RangeEvent.swift
//  BeaconScanner
//
//  Created by Matt on 1/5/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

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
