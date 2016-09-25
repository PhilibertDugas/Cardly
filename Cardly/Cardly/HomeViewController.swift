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
import FirebaseDatabase
import FirebaseStorage

class HomeViewController: UICollectionViewController {
    var photos = Photo.allPhotos()
    var closeUsers = [(NSMutableDictionary)]()
    var databaseReference: FIRDatabaseReference!
    var storageReference: FIRStorageReference!

    
    let regionUUID = UUID(uuidString: Constants.Bluetooth.RegionUUID)!
    let beaconListener = BeaconListener.init()
    
    var advertisedData = NSDictionary()
    var beaconRegion: CLBeaconRegion!
    var peripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReference = FIRDatabase.database().reference()
        storageReference = FIRStorage.storage().reference(forURL: "gs://cardly-86595.appspot.com")

        if let layout = collectionView?.collectionViewLayout as? CardlyLayout {
            layout.delegate = self
        }
        launchBluetoothDevice()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.closeUsersUpdate), name: NSNotification.Name(rawValue: Constants.Notifications.BeaconFound), object: nil)
        
        beaconListener.startMonitoring()
    }
}

extension HomeViewController {
    func closeUsersUpdate(_ notification: Notification) {
        let minors = notification.userInfo!["data"] as! NSArray
        databaseReference.observeSingleEvent(of: .value, with:  { (snapshot) in
            let dict = snapshot.value! as? NSDictionary
            let users = dict?["users"] as! NSDictionary
            var currentCloseUsers = [NSMutableDictionary]()
            for (firebaseId, user) in users {
                let userDict = user as! NSMutableDictionary
                let minor = userDict["minor"]! as! String
                if minors.contains(minor) {
                    userDict.setValue(firebaseId as! String, forKey: "firebaseId")
                    currentCloseUsers.append(userDict)
                }
            }
            self.closeUsers = currentCloseUsers
            self.collectionView?.reloadData()
        })
        print(minors)
    }
    
    func fetchUserImage(index: Int) -> UIImage? {
        let user = closeUsers[index]
        let urlRequest = URL(string: user["photoURL"] as! String)
        let data = try? Data(contentsOf: urlRequest!)
        let image = UIImage(data: data!)!
        return image
    }
    
    func launchBluetoothDevice() {
        beaconRegion = CLBeaconRegion(proximityUUID: regionUUID, major: AppState.sharedInstance.major!, minor: AppState.sharedInstance.minor!, identifier: Constants.Bluetooth.BeaconIdentifier)
        advertisedData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
}


extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return closeUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.HomeCollectionViewCell, for: indexPath) as! AnnotatedPhotoCell
        
        let user = closeUsers[indexPath.row]
        
        if let image = user["image"] as? UIImage {
            cell.imageView.image = image
        } else {
            let image = fetchUserImage(index: indexPath.row)
            user["image"] = image
            cell.imageView.image = image
        }
        cell.captionLabel.text = user["username"] as? String
        return cell
    }
}

extension HomeViewController: CardlyLayoutDelegate {
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let user = closeUsers[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        var rect: CGRect
        if let image = user["image"] as? UIImage {
            rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
        } else {
            let image = fetchUserImage(index: indexPath.row)
            user["imager"] = image
            rect = AVMakeRect(aspectRatio: (image?.size)!, insideRect: boundingRect)
        }
        return rect.size.height
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let user = closeUsers[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let rect = NSString(string: user["username"] as! String).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        let nameHeight = ceil(rect.height)
        let height = annotationPadding + annotationHeaderHeight + nameHeight + annotationPadding
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
