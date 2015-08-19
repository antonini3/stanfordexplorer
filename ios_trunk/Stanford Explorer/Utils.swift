//
//  Utils.swift
//  Stanford Explorer
//
//  Created by Anton Apostolatos on 8/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

func synced(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}