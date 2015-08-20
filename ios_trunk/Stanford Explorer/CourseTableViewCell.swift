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
    
    
//    @IBAction func storeCourse(sender: AnyObject) {
////        courseStored = !courseStored
////        appDelegate.storeCourse(courseStored, course: course!)
//    }
    
    
    var courseStored: Bool? {
        didSet {
            if courseStored != nil && courseStored == false {
                storeButtonOutlet.setTitle("NOT SAVED", forState: .Normal)
            } else {
                storeButtonOutlet.setTitle("CLASS SAVED", forState: .Normal)
            }
        }
    }
    
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat { get { return 50 } }
    
    @IBOutlet weak var storeButtonOutlet: UIButton!
    
    @IBAction func storeButton(sender: AnyObject) {
        courseStored = (courseStored != true)
        appDelegate.storeCourse(courseStored!, course: course!)
    }
    func checkHeight() {
        var shouldHide = (frame.size.height < CourseTableViewCell.expandedHeight)
        descriptionLabel?.hidden = shouldHide
        storeButtonOutlet?.hidden = shouldHide
    }
    
    func watchFrameChanges() {
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        checkHeight()
    }
    
    func ignoreFrameChanges() {
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }

}
