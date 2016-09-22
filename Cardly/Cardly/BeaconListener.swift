//
//  BeaconListener.swift
//  contatcz
//
//  Created by Philibert Dugas on 2016-07-20.
//  Copyright © 2016 qh4l. All rights reserved.
//

import CoreLocation

class BeaconListener: NSObject, CLLocationManagerDelegate {
    let regionUUID = UUID(uuidString: Constants.Bluetooth.RegionUUID)!
    let notificationCenter = NotificationCenter.default
    
    var locationManager = CLLocationManager()
    var beaconRegion: CLBeaconRegion
    
    var beaconFoundCounter = 0
    
    override init() {
        beaconRegion = CLBeaconRegion(proximityUUID: regionUUID, identifier: Constants.Bluetooth.BeaconIdentifier)
        super.init()
    }
    
    func startMonitoring() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: self.beaconRegion)
        locationManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
        /*let beaconArray = NSMutableArray()
         for beacon in beacons {
         beaconArray.add("\(beacon.minor)")
         }*/
        let beaconArray = ["1", "2"]
        let notificationData = ["data": beaconArray]
        if beaconFoundCounter == 3 {
            print("Posting: \(beaconArray)")
            beaconFoundCounter = 0
            notificationCenter.post(name: Notification.Name(rawValue: Constants.Notifications.BeaconFound), object: nil, userInfo: notificationData)
        } else {
            beaconFoundCounter += 1
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started monitoring for region. Region: \(region.description)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring for region. Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed. Error: \(error)")
    }
    
}
