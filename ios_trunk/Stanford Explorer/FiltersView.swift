//
//  FiltersView.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/24/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class FiltersView: UIView {
    
    var extendedHeight: Double?
    
    var shortenedHeight: Double = 30
    
    var filtersIsAnimating: Bool = false
    
    var blurIsAnimating: Bool = false
    
    var filtersIsDisplayed: Bool = false
    
    var parentViewController: SearchViewController?
    
    var blurView: UIView?
    
    @IBOutlet var filterButton: UIButton!
    
    @IBAction func openFilters(sender: AnyObject) {
        
        if (filtersIsDisplayed) {
            hideFilters()
            //animateBlur(false) {}
        } else {
            showFilters()
            //animateBlur(true) {}
        }
       
    }
    
    func hideFilters() {
        var frame = CGRect(x: Double(self.frame.origin.x), y: Double(self.frame.origin.y), width: Double(self.frame.width), height: shortenedHeight)
        self.animateFrame(frame) {
            self.parentViewController!.dismissKeyboard()
            self.filtersIsDisplayed = false
        }
    }
    
    func showFilters() {
        var frame = CGRect(x: Double(self.frame.origin.x), y: Double(self.frame.origin.y), width: Double(self.frame.width), height: extendedHeight!)
        self.animateFrame(frame) {
            
            self.parentViewController!.dismissKeyboard()
            self.filtersIsDisplayed = true
        }
    }
    
    func animateFrame(frame: CGRect, completion: () -> Void) {
    
        let c = { (completed: Bool) -> Void in
            self.filtersIsAnimating = false
            if (completed) {
                completion()
            }
        }
        
        if (!self.filtersIsAnimating) {
            self.filtersIsAnimating = true
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.frame = frame
//                var newFrame = self.filterButton.frame
//                newFrame.origin.y += 50
//                self.filterButton.frame = newFrame

                }, completion: c
            )
        }

//        UIView.animateWithDuration(0.5 as NSTimeInterval, delay: 0.2 as NSTimeInterval, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//            self.filterButton.frame = CGRectMake(
//                self.filterButton.frame.origin.x,
//                self.filterButton.frame.origin.y + 50,
//                self.filterButton.frame.size.width,
//                self.filterButton.frame.size.height)
//        }, completion: nil)
    }
    
}
