//
//  AppDelegate.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/16/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit
import Parse
import Bolts

var kStatusBarTappedNotification: NSString = "statusBarTappedNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var DBAccess: DatabaseAccess?
    
    var localDatastore: LocalDatastore?
    
    func setupParse(launchOptions: [NSObject: AnyObject]?) {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("73JV0YvepwnVJgCPgxztpOaRZGYTWSpYJGo4r3lH", clientKey:"HgY1gtfUZpJ67YbKqt7UvYDTvoe9hkAqhrIuXcn5")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
    }
    

    
    func setupDBAccess() {
        self.DBAccess = DatabaseAccess()
    }
    
    func setupLocalDatastore() {
        self.localDatastore = LocalDatastore()
        localDatastore?.clear()
    }
    
    func getCourseListFromAD(searchText: String, limit: Int, skip: Int, cb: ([Course]) -> ()) {
        self.DBAccess!.getCourseList(searchText, limit: limit, skip: skip, callback: cb)
    }
    
    func getStoredCourses(cb: ([Course]) -> ()) {
        self.localDatastore!.getStoredCourses(cb)
    }
    
    func storeCourse(courseStored: Bool, course: Course) {
        localDatastore!.storeCourse(courseStored, course: course)
    }
    
    func isCourseStored(course: Course) -> Bool {
        return localDatastore!.isCourseStored(course)
    }
    
    func getStoredCourseListFromAD(callback: ([Course]) -> ()) {
        self.localDatastore!.getStoredCourses(callback)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        setupParse(launchOptions)
        
        setupDBAccess()
        setupLocalDatastore()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

