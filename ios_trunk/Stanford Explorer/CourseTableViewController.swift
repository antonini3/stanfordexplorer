//
//  CourseTableViewController.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/23/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit



class CourseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let NUM_ITEMS_PER_QUERY: Int = 15
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var selectedIndexPath: NSIndexPath?
    
    var courses: [Course]!
    
    @IBOutlet weak var courseTable: UITableView!
    
    var noMoreResults: Bool = false
    
    var storedCourses: Bool = false
    
    var searchBarText: String?
    
    var parentVC: UIViewControllerWrapper?
    
    let cellID = "Cell"
    
    func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        self.courseTable.scrollsToTop = true
        
        if let parentVC = parentVC as? SearchViewController {
            storedCourses = false
        } else if let parentVC = parentVC as? StoredCoursesViewController {
            storedCourses = true
        } else {
            NSLog("Error getting ahold of parent class")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = []
        self.courseTable.delegate = self
        self.courseTable.dataSource = self
        self.courseTable.tableFooterView = UIView(frame: CGRectZero)
        
        
        setup()
        
        reloadStoredCourses()
        
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        reloadStoredCourses()
//    }
    
    func reloadStoredCourses() {
        if storedCourses {
            appDelegate.getStoredCourseListFromAD(searchBarCallback)
        }
    }
    
    func reloadStoredCourse(course: Course, newState: Bool, indexPath: NSIndexPath) {
        if newState == false {
            self.courseTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            reloadStoredCourses()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func clearExpandedCell(animation: Bool) {
        if animation {
            var indexPaths: Array<NSIndexPath> = []
            let previousIndexPath = selectedIndexPath
            selectedIndexPath = nil
            if let previous = previousIndexPath {
                self.courseTable.reloadRowsAtIndexPaths([previous], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        } else {
            self.selectedIndexPath = nil
        }
    }
    
    
    func keyboardWillAppear(notification: NSNotification) {
        var indexPaths: Array<NSIndexPath> = []
        let previousIndexPath = selectedIndexPath
        selectedIndexPath = nil
        if let previous = previousIndexPath {
            self.courseTable.reloadRowsAtIndexPaths([previous], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func runSearch(searchText: String) {
        self.noMoreResults = false
        self.searchBarText = searchText
        appDelegate.getCourseListFromAD(searchText, limit: NUM_ITEMS_PER_QUERY, skip: 0, cb: searchBarCallback)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarCallback(courses: [Course]) {
        self.courses = courses
        self.courseTable.reloadData()
    }
    
    func searchBarReloadCallback(courses: [Course]) {
        if courses.count == 0 {
            noMoreResults = true
            return
        }
        var indexPaths: Array<NSIndexPath> = []
        for var index = 0; index < NUM_ITEMS_PER_QUERY; ++index {
            indexPaths.append(NSIndexPath(forItem: index + self.courses.count, inSection: 0))
        }
        self.courses.extend(courses)
        self.courseTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.courseTable.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! CourseTableViewCell
        cell.nameLabel.text = courses[indexPath.row].courseTitle

        
        if indexPath.row == self.courses.count - 1 {
            if indexPath.row == self.courses.count - 1 && !noMoreResults && !storedCourses {
                self.launchReload()
            }
        }
       
        
        cell.course = courses[indexPath.row]
        
        cell.courseStored = appDelegate.isCourseStored(courses[indexPath.row])
        
        cell.parentVC = self.parentVC
        
        cell.indexPath = indexPath
        
        return cell
    }
    
    
    func launchReload() {
        appDelegate.getCourseListFromAD(self.searchBarText!, limit: NUM_ITEMS_PER_QUERY, skip: courses.count, cb: searchBarReloadCallback)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissKeyboard()
        let previousIndexPath = selectedIndexPath
        
        if indexPath == previousIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths: Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            if previousIndexPath?.row < self.courses.count {
                indexPaths += [previous]
            }
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! CourseTableViewCell).watchFrameChanges()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! CourseTableViewCell).ignoreFrameChanges()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return CourseTableViewCell.expandedHeight
        } else {
            return CourseTableViewCell.defaultHeight
        }
    }
    
    
}