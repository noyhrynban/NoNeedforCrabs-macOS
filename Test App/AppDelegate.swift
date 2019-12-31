//
//  AppDelegate.swift
//  Test App
//
//  Created by Ryan on 11/4/19.
//  Copyright © 2019 Ryan Harper. All rights reserved.
//

import Cocoa
import Metal

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        MTLCopyAllDevices()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

