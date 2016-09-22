//
//  BeaconAdvertiser.swift
//  contatcz
//
//  Created by Philibert Dugas on 2016-07-20.
//  Copyright © 2016 qh4l. All rights reserved.
//

import CoreBluetooth
import CoreLocation


class BeaconAdvertiser: NSObject, CBPeripheralManagerDelegate {
    let regionUUID = UUID(uuidString: Constants.Bluetooth.RegionUUID)!
    
    var advertisedData = NSDictionary()
    var beaconRegion: CLBeaconRegion
    var peripheralManager: CBPeripheralManager!
    
    init(minor: CLBeaconMinorValue, major: CLBeaconMajorValue) {
        beaconRegion = CLBeaconRegion(proximityUUID: regionUUID, major: major, minor: minor, identifier: Constants.Bluetooth.BeaconIdentifier)
        self.advertisedData = beaconRegion.peripheralData(withMeasuredPower: nil)
        super.init()
    }
    
    func startAdvertising() {
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
    
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case CBManagerState.poweredOn:
            print("Bluetooth is powered on")
            self.peripheralManager.startAdvertising(self.advertisedData as? [String : AnyObject])
        case CBManagerState.poweredOff:
            print("Bluetooth is powered off")
        case CBManagerState.resetting:
            print("Bluetooth is restting")
        case CBManagerState.unsupported:
            print("Bluetooth unknown state")
        case CBManagerState.unauthorized:
            print("Bluetooth unauthorized")
        default:
            print("nothing")
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("Started advertising minor: \(beaconRegion.minor) major: \(beaconRegion.major)")
    }

    
}
