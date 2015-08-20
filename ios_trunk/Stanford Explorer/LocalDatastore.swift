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
    
    
    func storeCourse(storeCourse: Bool, course: Course?) {
        if storeCourse {
            let newCourse = PFObject(className: "storeCourses")
            newCourse["title"] = course?.courseTitle
            newCourse.pin()
        } else {
            var query = PFQuery(className: "storeCourses")
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
        for obj in query.findObjects()! {
            courses.append(Course(elem: obj as! PFObject))
        }
        callback(courses)
    }
    
    
}