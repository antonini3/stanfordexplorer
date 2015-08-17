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
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var selectedIndexPath: NSIndexPath?

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var courseTable: UITableView!
    
    var courses: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true

        courses = []
        self.courseTable.delegate = self
        self.courseTable.dataSource = self
        self.courseTable.tableFooterView = UIView(frame: CGRectZero)
        

//        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
//        
//        searchBar.setImage(UIImage(named: "SearchWhite"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);
//        
//        var searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
//        if searchTextField!.respondsToSelector(Selector("attributedPlaceholder")) {
//            var color = UIColor.whiteColor()
//            let attributeDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search for Courses", attributes: attributeDict)
//        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func searchBar(_classSearch: UISearchBar, textDidChange searchText: String) {
        appDelegate.getCourseListFromAD(searchText, cb: searchBarCallback)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        appDelegate.getCourseListFromAD(searchBar.text, cb: searchBarCallback)
        dismissKeyboard()
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarCallback(courses: [String]) {
        self.courses = courses
        self.courseTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.courseTable.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! CourseTableViewCell
        cell.nameLabel.text = courses[indexPath.row]
        cell.descriptionLabel.text = "DESC OF " + courses[indexPath.row]
        return cell
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


