//
//  RootViewController.swift
//  Cardly
//
//  Created by Philibert Dugas on 2016-09-24.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var pageViewController: UIPageViewController!
    let pageTitles = ["Over 200 Tips and Tricks", "Discover Hidden Features", "Bookmark Favorite Tip", "Free Regular Update"]
    let pageImages = ["page1.png", "page2.png", "page3.png", "page4.png"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController!
        pageViewController.dataSource = self
        
        let startingViewController = viewControllerAtIndex(0)!
        
        pageViewController.setViewControllers([startingViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 50)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RootViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentController).pageIndex!
        
        if index == 0 || index == NSNotFound {
            return nil;
        }
        
        index -= 1;
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentController).pageIndex!

        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == pageTitles.count {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func viewControllerAtIndex(_ index: Int) -> PageContentController? {
        if index >= self.pageTitles.count {
            return nil
        }
        
        let pageContentController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentController") as! PageContentController
        pageContentController.imageFile = self.pageImages[index]
        pageContentController.titleText = self.pageTitles[index]
        pageContentController.pageIndex = index
        return pageContentController
    }
}
