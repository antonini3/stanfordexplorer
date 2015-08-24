//
//  UIViewControllerWrapper.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/23/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class UIViewControllerWrapper: UIViewController {
    
    func fromSearchUpdateToSaved(course: Course) {
        assert(false, "fromSearchUpdateToSaved must be overriden by the subclass")
    }
    
    func fromSearchUpdateToUnsaved(course: Course) {
        assert(false, "fromSearchUpdateToUnsaved must be overriden by the subclass")
    }
    
    func fromStoredCourseUpdateToSaved(course: Course) {
        assert(false, "fromStoredCourseUpdateToSaved must be overriden by the subclass")
    }
    
    func fromStoredCourseUpdateToUnsaved(course: Course) {
        assert(false, "fromStoredCourseUpdateToUnsaved must be overriden by the subclass")
    }
}