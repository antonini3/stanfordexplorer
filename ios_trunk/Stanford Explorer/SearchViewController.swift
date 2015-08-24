//
//  SearchViewController.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewControllerWrapper, UISearchBarDelegate {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var searchBar: UISearchBar!
    
    var courseTableViewController: CourseTableViewController?
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "courseTableViewControllerSegue" {
            self.courseTableViewController = (segue.destinationViewController as! CourseTableViewController)
            self.courseTableViewController?.parentVC = self
        }
    }
    
    func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        var searchImage: UIImage = UIImage(named: "cardinal_search")!
        self.searchBar.setImage(searchImage, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        var cancelImage: UIImage = UIImage(named: "cardinal_cancel")!
        self.searchBar.setImage(cancelImage, forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true
        setup()
        
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func searchBar(_classSearch: UISearchBar, textDidChange searchText: String) {
        self.courseTableViewController?.clearExpandedCell(true)
        self.courseTableViewController?.runSearch(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.courseTableViewController?.clearExpandedCell(true)
        self.courseTableViewController?.runSearch(searchBar.text)
        dismissKeyboard()
    }
    
//    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
//        self.courseTableViewController?.clearExpandedCell(false)
//        return true
//    }
    
    
    func keyboardWillAppear(notification: NSNotification) {
        self.courseTableViewController?.clearExpandedCell(true)
    }
    
    override func fromSearchUpdateToSaved(course: Course) {
        (self.parentViewController as! MainViewController).storedCoursesVC?.courseTableViewController?.reloadStoredCourses()
    }
    
    override func fromSearchUpdateToUnsaved(course: Course) {
        var storedCourseTableVC = (self.parentViewController as! MainViewController).storedCoursesVC?.courseTableViewController
        storedCourseTableVC?.removeCourseWithAnimation(course)
    }
    
}


