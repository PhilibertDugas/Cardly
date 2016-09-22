//
//  HomeViewController.swift
//  Cardly
//
//  Created by Philibert Dugas on 2016-09-21.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class HomeViewController: UIViewController, CBPeripheralManagerDelegate {
    let regionUUID = UUID(uuidString: Constants.Bluetooth.RegionUUID)!
    
    var advertisedData = NSDictionary()
    var beaconRegion: CLBeaconRegion!
    var peripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchBluetoothDevice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func launchBluetoothDevice() {
        let beaconListener = BeaconListener.init()
        beaconListener.startMonitoring()
        
        beaconRegion = CLBeaconRegion(proximityUUID: regionUUID, major: 1, minor: 1, identifier: Constants.Bluetooth.BeaconIdentifier)
        advertisedData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case CBManagerState.poweredOn:
            print("Bluetooth is powered on")
            self.peripheralManager.startAdvertising(self.advertisedData as? [String : AnyObject])
        case CBManagerState.poweredOff:
            print("Bluetooth is powered off")
        default:
            print("nothing")
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("Started advertising minor: \(beaconRegion.minor) major: \(beaconRegion.major)")
    }

}
