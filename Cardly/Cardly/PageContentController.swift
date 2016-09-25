//
//  PageContentController.swift
//  Cardly
//
//  Created by Philibert Dugas on 2016-09-24.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit

class PageContentController: UIViewController {
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundImage.image = UIImage(named: imageFile)
        self.titleLabel.text = titleText
    }
}
