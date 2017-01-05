//
//  MonitorEvent.swift
//  BeaconScanner
//
//  Created by Matt on 1/5/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import CoreLocation

class MonitorEvent {
    let beacon: CLBeaconRegion
    let type: MonitorEventType
    
    init(beacon: CLBeaconRegion, type: MonitorEventType) {
        self.beacon = beacon
        self.type = type
    }
}
