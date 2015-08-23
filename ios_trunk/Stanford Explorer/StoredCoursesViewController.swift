//
//  StoreCoursesViewController.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit

class StoredCoursesViewController: UIViewControllerWrapper {
    
    var courseTableViewController: CourseTableViewController?
    

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "storedCourseTableViewControllerSegue" {
            self.courseTableViewController = (segue.destinationViewController as! CourseTableViewController)
            self.courseTableViewController?.parentVC = self
        }
    }
    
    override func changedCourse(course: Course, newState: Bool, indexPath: NSIndexPath) {
        self.courseTableViewController?.reloadStoredCourse(course, newState: newState, indexPath: indexPath)
    }
    
    
}

