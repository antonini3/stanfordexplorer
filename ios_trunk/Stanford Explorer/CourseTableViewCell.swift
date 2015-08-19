//
//  CourseTableViewCell.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat { get { return 100 } }
    
    func checkHeight() {
        descriptionLabel?.hidden = (frame.size.height < CourseTableViewCell.expandedHeight)
        
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
