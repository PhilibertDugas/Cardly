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
import AVFoundation

class HomeViewController: UICollectionViewController {
    var photos = Photo.allPhotos()
    
    let regionUUID = UUID(uuidString: Constants.Bluetooth.RegionUUID)!
    let beaconListener = BeaconListener.init()
    
    var advertisedData = NSDictionary()
    var beaconRegion: CLBeaconRegion!
    var peripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? CardlyLayout {
            layout.delegate = self
        }
        launchBluetoothDevice()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.closeUsersUpdate), name: NSNotification.Name(rawValue: Constants.Notifications.BeaconFound), object: nil)
        
        beaconListener.startMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HomeViewController {
    func closeUsersUpdate(_ notification: Notification) {
        let minors = notification.userInfo!["data"] as! NSArray
        print(minors)
    }
    
    func launchBluetoothDevice() {
        beaconRegion = CLBeaconRegion(proximityUUID: regionUUID, major: 1, minor: 1, identifier: Constants.Bluetooth.BeaconIdentifier)
        advertisedData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
}


extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.HomeCollectionViewCell, for: indexPath) as! AnnotatedPhotoCell
        cell.photo = photos[indexPath.item]
        return cell
    }
}

extension HomeViewController: CardlyLayoutDelegate {
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let photo = photos[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: photo.image.size, insideRect: boundingRect)
        return rect.size.height
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let photo = photos[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = photo.heightForComment(font: font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
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
            print("Unknown bluetooth state")
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("Started advertising minor: \(beaconRegion.minor) major: \(beaconRegion.major)")
    }
}
