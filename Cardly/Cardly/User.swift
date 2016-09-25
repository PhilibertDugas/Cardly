//
//  User.swift
//  Cardly
//
//  Created by Philibert Dugas on 2016-09-24.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit

class User {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let name = dictionary["Name"] as? String
        let image = dictionary["Photo"] as? UIImage
        self.init(name: name!, image: image!)
    }
    
    func heightForName(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: name).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
