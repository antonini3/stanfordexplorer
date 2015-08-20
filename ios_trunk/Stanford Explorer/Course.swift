//
//  Course.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import Parse

class Course {
    var courseTitle: String?
    
    init(course: String) {
        courseTitle = course
    }
    
    init(elem: PFObject) {
        courseTitle = elem["title"] as? String
    }
}