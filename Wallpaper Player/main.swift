//
//  main.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/5.
//

import Cocoa
import OSLog

// OS Logger
let logger                      =                         Logger()

// Global Settings
let globalSettingsController    =  GlobalSettingsController.shared

// App Notifications
let notificationController      =    NotificationController.shared

// Apply/Restore Original Desktop Image
let systemWallpaperController   = SystemWallpaperController.shared

// Menu Bar
let menuBarController           =         MenuBarController.shared

// Status Bar
let statusBarController         =       StatusBarController.shared

// Delegates & Windows & Views
let appController               =             AppController.shared

//
// I tried my best to avoid delegation pattern but have no choice.
//
// The reason is that some delegate methods don't have their
// equivalent NotificationCenter notifications to be transformed
// into Combine publishers.
//
NSApplication.shared.delegate = appController

NSApplication.shared.run()

