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

class HomeViewController: UIViewController {
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
    }
    
    func launchBluetoothDevice() {
        let beaconListener = BeaconListener.init()
        beaconListener.startMonitoring()
        
        beaconRegion = CLBeaconRegion(proximityUUID: regionUUID, major: 1, minor: 1, identifier: Constants.Bluetooth.BeaconIdentifier)
        advertisedData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.HomeCollectionViewCell, for: indexPath)
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    

}

extension HomeViewController: CBPeripheralManagerDelegate {
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
