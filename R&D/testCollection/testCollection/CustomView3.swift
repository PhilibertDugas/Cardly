//
//  CustomView3.swift
//  testCollection
//
//  Created by Guillaume Lalande on 2016-09-23.
//  Copyright © 2016 G4. All rights reserved.
//

import UIKit

class CustomView3: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomView3", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
