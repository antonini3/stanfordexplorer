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
    
    var searchVC: SearchViewController?
    
    var storedCoursesVC: StoredCoursesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        initScrollView()
    }
    
    func initScrollView(){
        searchVC = storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as? SearchViewController
        
        searchVC!.willMoveToParentViewController(self)
        searchVC!.view.frame = scrollView.bounds
        
        storedCoursesVC = storyboard?.instantiateViewControllerWithIdentifier("StoredCoursesViewController") as? StoredCoursesViewController
        
        storedCoursesVC!.willMoveToParentViewController(self)
        storedCoursesVC!.view.frame.size = scrollView.frame.size
        storedCoursesVC!.view.frame.origin = CGPoint(x: view.frame.width, y: 0)
        
        scrollView.contentSize = CGSize(width: 2 * scrollView.frame.width, height: scrollView.frame.height)
        
        scrollView.addSubview(storedCoursesVC!.view)
        self.addChildViewController(storedCoursesVC!)
        storedCoursesVC!.didMoveToParentViewController(self)
        
        scrollView.addSubview(searchVC!.view)
        self.addChildViewController(searchVC!)
        searchVC!.didMoveToParentViewController(self)
    }
}