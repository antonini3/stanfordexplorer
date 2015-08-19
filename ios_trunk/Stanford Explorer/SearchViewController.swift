//
//  SearchViewController.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit

let cellID = "cell"

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let NUM_ITEMS_PER_QUERY: Int = 15
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var selectedIndexPath: NSIndexPath?

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var courseTable: UITableView!
    
    var courses: [String]!
    
    var noMoreResults: Bool = false
    
    func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        self.courseTable.scrollsToTop = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true

        courses = []
        self.courseTable.delegate = self
        self.courseTable.dataSource = self
        self.courseTable.tableFooterView = UIView(frame: CGRectZero)
        
        setup()
        
    }

    func dismissKeyboard() {
        view.endEditing(true)
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

    
    func searchBar(_classSearch: UISearchBar, textDidChange searchText: String) {
        noMoreResults = false
        appDelegate.getCourseListFromAD(searchText, limit: NUM_ITEMS_PER_QUERY, skip: 0, cb: searchBarCallback)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        noMoreResults = false
        appDelegate.getCourseListFromAD(searchBar.text, limit: NUM_ITEMS_PER_QUERY, skip: 0, cb: searchBarCallback)
        dismissKeyboard()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
//        selectedIndexPath = nil
        return true
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarCallback(courses: [String]) {
        self.courses = courses
        self.courseTable.reloadData()
    }
    
    func searchBarReloadCallback(courses: [String]) {
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
        cell.nameLabel.text = courses[indexPath.row]
        cell.descriptionLabel.text = "DESC OF " + courses[indexPath.row]
        
        if indexPath.row == self.courses.count - 1 && !noMoreResults {
            self.launchReload()
        }
        
        return cell
    }

    
    func launchReload() {
        appDelegate.getCourseListFromAD(searchBar.text, limit: NUM_ITEMS_PER_QUERY, skip: courses.count, cb: searchBarReloadCallback)
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


