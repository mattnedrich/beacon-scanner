//
//  CLBeaconRegionExtensions.swift
//  CodemashIBeaconDemo
//
//  Created by Matt on 1/2/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import CoreLocation

extension CLBeaconRegion {
    var printString: String {
        return "UUID: \(self.proximityUUID.uuidString), major: \(String(describing: self.major)), minor: \(String(describing: self.minor))"
    }
}

extension CLProximity {
    var printString: String {
        switch self {
        case CLProximity.far: return "Far"
        case CLProximity.near: return "Near"
        case CLProximity.immediate: return "Immediate"
        default: return "Unknown"
        }
    }
}
