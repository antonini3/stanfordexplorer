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
    
    var parentView: UIView?
    
    var blurView: UIView?
    
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
            self.filtersIsDisplayed = false
        }
    }
    
    func showFilters() {
        var frame = CGRect(x: Double(self.frame.origin.x), y: Double(self.frame.origin.y), width: Double(self.frame.width), height: extendedHeight!)
        self.animateFrame(frame) {
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

                }, completion: c
            )
        }
    }
    
    func animateBlur(shouldBlur: Bool, completion: () -> Void) {
        
        let c = { (completed: Bool) -> Void in
            self.blurIsAnimating = false
            if (completed) {
                completion()
            }
        }
        
        if (!self.blurIsAnimating) {
            self.blurIsAnimating = true
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                if self.blurView == nil {
                    self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
                    self.blurView!.frame = self.parentView!.bounds
                    self.parentView!.addSubview(self.blurView!)
                }
                if shouldBlur {
                    self.blurView?.removeFromSuperview()
                } else {
                    self.parentView!.insertSubview(self.blurView!, belowSubview: self)
                }
                }, completion: c
            )
        }
        

    }
    

}
