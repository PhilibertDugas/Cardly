//
//  AppState.swift
//  Cardly
//
//  Created by Philibert Dugas on 2016-09-20.
//  Copyright © 2016 QH4L. All rights reserved.
//

import Foundation

class AppState: NSObject {
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoUrl: URL?
}
