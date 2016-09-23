//
//  CollectionViewCell.swift
//  testCollection
//
//  Created by Guillaume Lalande on 2016-09-23.
//  Copyright © 2016 G4. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var customView: UIView?
    
    var pageControl: UIPageControl?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.pageControl = UIPageControl()
//        self.pageControl?.frame = CGRect(x: 0, y: 0, width: 185, height: 185)
//        self.pageControl?.numberOfPages = 2
//        self.pageControl?.currentPage = 0
//        self.addSubview(self.pageControl!)
//        pageControl?.backgroundColor = UIColor.clear
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl?.currentPage = Int(page)
    }
}
