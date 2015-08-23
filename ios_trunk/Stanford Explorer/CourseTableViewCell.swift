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
    
    var indexPath: NSIndexPath?
    
    
    @IBAction func storeCourse(sender: AnyObject) {
        courseStored = !courseStored!
        resetCourseStoredTitle()
        appDelegate.storeCourse(courseStored!, course: course!)
        parentVC?.changedCourse(course!, newState: courseStored!, indexPath: indexPath!)
    }
    
    
    var courseStored: Bool? {
        didSet {
            resetCourseStoredTitle()
        }
    }
    
    func resetCourseStoredTitle() {
        if courseStored != nil && courseStored == false {
            storeButtonOutlet.setTitle("NOT SAVED", forState: .Normal)
        } else {
            storeButtonOutlet.setTitle("CLASS SAVED", forState: .Normal)
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
