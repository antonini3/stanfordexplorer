//
//  MainViewController.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        initScrollView()
    }
    
    func initScrollView(){
        let viewController1 = storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        
        viewController1.willMoveToParentViewController(self)
        viewController1.view.frame = scrollView.bounds
        
        let viewController2 = storyboard?.instantiateViewControllerWithIdentifier("StoredCoursesViewController") as! StoredCoursesViewController
        
        viewController2.willMoveToParentViewController(self)
        viewController2.view.frame.size = scrollView.frame.size
        viewController2.view.frame.origin = CGPoint(x: view.frame.width, y: 0)
        
        scrollView.contentSize = CGSize(width: 2 * scrollView.frame.width, height: scrollView.frame.height)
        
        scrollView.addSubview(viewController2.view)
        self.addChildViewController(viewController2)
        viewController2.didMoveToParentViewController(self)
        
        scrollView.addSubview(viewController1.view)
        self.addChildViewController(viewController1)
        viewController1.didMoveToParentViewController(self)
    }
}