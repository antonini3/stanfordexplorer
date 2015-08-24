//
//  CourseTableViewCell.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class CourseTableViewCell: UITableViewCell {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var course: Course?
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    var parentVC: UIViewControllerWrapper?
    
    var observer: Bool = false
    
    @IBAction func storeCourse(sender: AnyObject) {
        courseStored = !courseStored!
        appDelegate.storeCourse(courseStored!, course: course!)
        
        if let tempParentVC = self.parentVC {
            if let tempParentVC = tempParentVC as? StoredCoursesViewController {
                if courseStored! {
                    NSLog("Trying to store a course already stored; logical inconsistency")
                } else {
                    self.parentVC?.fromStoredCourseUpdateToUnsaved(course!)
                }
            } else if let tempParentVC = tempParentVC as? SearchViewController {
                if courseStored! {
                    self.parentVC?.fromSearchUpdateToSaved(course!)
                } else {
                    self.parentVC?.fromSearchUpdateToUnsaved(course!)
                }
            }
        }
    }
    
    
    var courseStored: Bool? {
        didSet {
            resetCourseStoredTitle()
        }
    }
    
    func resetCourseStoredTitle() {
        if courseStored != nil && courseStored == false {
            storeButtonOutlet.selected = false
        } else {
            storeButtonOutlet.selected = true
        }
    }
    
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat { get { return 50 } }
    
    @IBOutlet weak var storeButtonOutlet: UIButton!
    
    func checkHeight() {
        var shouldHide = (frame.size.height < CourseTableViewCell.expandedHeight)
        descriptionLabel?.hidden = shouldHide
        storeButtonOutlet?.hidden = shouldHide
    }
    
    func watchFrameChanges() {
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        observer = true
        checkHeight()
    }
    
    func ignoreFrameChanges() {
        if observer {
            removeObserver(self, forKeyPath: "frame")
            observer = false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }

}
