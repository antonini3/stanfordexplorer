//
//  LocalDatastore.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import Parse

class LocalDatastore {
    
    func clear() {
        var query = PFQuery(className: "storeCourses")
        query.fromLocalDatastore()
        var courses = [Course]()
        var objects = query.findObjects()
        PFObject.unpinAll(objects)
    }
    
    
    func storeCourse(storeCourse: Bool, course: Course?) {
        if storeCourse {
            NSLog("ADD COURSE!")
            let newCourse = PFObject(className: "storeCourses")
            newCourse["title"] = course?.courseTitle
            newCourse.pin()
        } else {
            NSLog("REMOVE COURSE!")
            var query = PFQuery(className: "storeCourses")
            var courseTitle: String = course!.courseTitle!
            query.whereKey("title", equalTo: courseTitle)
            query.fromLocalDatastore()
            var courseToDelete = query.getFirstObject()
            courseToDelete?.unpinInBackground()
        }
    }
    
    func isCourseStored(course: Course) -> Bool {
        var query = PFQuery(className: "storeCourses")
        query.fromLocalDatastore()
        query.whereKey("title", equalTo: course.courseTitle!)
        var storedCourse = query.getFirstObject()
        return (storedCourse != nil)
    }
    
    func getStoredCourses(callback: ([Course]) -> ()) {
        var query = PFQuery(className: "storeCourses")
        query.fromLocalDatastore()
        var courses = [Course]()
        var objects = query.findObjects()
        for obj in objects! {
            courses.append(Course(elem: obj as! PFObject))
        }
        
        callback(courses)
    }
    
    
}