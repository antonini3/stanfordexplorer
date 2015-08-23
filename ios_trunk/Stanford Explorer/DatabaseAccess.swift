//
//  DatabaseAccess.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import Parse
import Bolts

class DatabaseAccess {
    
    func getRegexSearchTerm(text: String) -> String {
        var searchText = text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if searchText == "" {
            return text
        }
        
        var regex = ""
        var spacer = "(?: )?"
        for ch in searchText {
            regex = regex + String(ch) + spacer
        }
        return regex
    }
    
    func getCourseList(searchText: String, limit: Int, skip: Int, callback: ([Course]) -> ()) {
        //If the user deletes everything in the query, we want to display nothing
        if searchText == "" {
            callback([])
        } else {
            var query = PFQuery(className: "exploreCourses2016")
            //we limit the query to 15
            query.limit = limit
            query.skip = skip
            
            
            //we regex the query, for capitalization, spaces etc
            var regex = self.getRegexSearchTerm(searchText)
            query.whereKey("full_title", matchesRegex: regex, modifiers: "i")
            
            NSLog(regex)
            
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    var courses = objects as! [PFObject]
                    var course_titles: [Course] = []
                    for c in courses {
                        var newCourse = Course(course: c["full_title"] as! String)
                        course_titles.append(newCourse)
                    }
                    callback(course_titles)
                } else {
                    // Log details of the failure
                    NSLog("Error in getCourseList: %@ %@", error!, error!.userInfo!)
                }
                
            }
        }
    }
    
}
