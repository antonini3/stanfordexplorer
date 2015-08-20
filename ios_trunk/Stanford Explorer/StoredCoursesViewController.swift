//
//  StoreCoursesViewController.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit

class StoredCoursesViewController: UIViewController {
    
    @IBOutlet weak var courseList: UILabel!
    
    var storedCourses: [Course]?
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate.getStoredCourses(getStoredCoursesCallback)
        
    }
    
    func getStoredCoursesCallback(courses: [Course]) {
        storedCourses = courses
        var str = ""
        for c in courses {
            str += "\n" + c.courseTitle!
        }
        courseList.text = str
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

