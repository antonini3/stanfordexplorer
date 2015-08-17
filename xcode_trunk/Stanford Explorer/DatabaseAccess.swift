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
    
    func getCourseList(searchText: String, callback: ([String]) -> ()) {
        //If the user deletes everything in the query, we want to display nothing
        if searchText == "" {
            callback([])
        } else {
            var query = PFQuery(className: "StanfordCourses2014")
            //we limit the query to 15
            query.limit = 15
            
            //we regex the query, for capitalization, spaces etc
            var regex = self.getRegexSearchTerm(searchText)
            query.whereKey("title", matchesRegex: regex, modifiers: "i")
            
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    var courses = objects as! [PFObject]
                    var course_titles: [String] = []
                    for c in courses {
                        course_titles.append(c["title"] as! String)
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
