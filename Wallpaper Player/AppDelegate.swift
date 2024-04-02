//
//  AppDelegate.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/6.
//

import Cocoa
import Combine
import SwiftUI
import AVKit
import WebKit

import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Window Controllers
    let mainWindowController = MainWindowController()
    
    let settingsWindowController = SettingsWindowController()
    
    let wallpaperWindowController = WallpaperWindowController()
    
    var statusItem: NSStatusItem?
    
    // Services
//    private var globalSettingsController = GlobalSettingsController()
//    
//    private var systemWallpaperController = SystemWallpaperController()
    
    let multiDisplayController = Legacy.MultiDisplayController()
    
    // Combine Cancellables
    var cancellable = Set<AnyCancellable>()
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if NSApp.keyWindow == nil {
            mainWindowController.showWindow(self)
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if NSApp.keyWindow == nil {
            mainWindowController.showWindow(self)
        }
        return true
    }
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        .dockMenu(delegate: self)
    }
    
    // MARK: - applicationDidFinishLaunching
    func applicationDidFinishLaunching(_ notification: Notification) {
        mainWindowController.wallpaperWindowController = wallpaperWindowController
        
        // Main Menu Bar & Status Bar
        NSApp.windowsMenu = .windowsMenu(delegate: self)
        NSApp.helpMenu = .helpMenu(delegate: self)
        NSApp.mainMenu = NSMenu {
            NSMenuItem(submenu: .appMenu(delegate: self))
            NSMenuItem(submenu: .fileMenu(delegate: self))
            NSMenuItem(submenu: .EditMenu(delegate: self))
            NSMenuItem(submenu: .viewMenu(delegate: self))
            NSMenuItem(submenu: NSApp.windowsMenu!)
            NSMenuItem(submenu: NSApp.helpMenu!)
        }
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem?.button?.image = .weLogo.withTemplateConfiguration()
        statusItem?.menu = .statusMenu(delegate: self)
        
        // Showing main window and wallpaper window on launch
        mainWindowController.showWindow(self)
        wallpaperWindowController.showWindow(self)
    }
}
