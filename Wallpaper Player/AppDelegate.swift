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
    
    var noNecessaryWindows: Bool {
        if let mainWindow = mainWindowController.window,
           let settingsWindow = settingsWindowController.window,
           mainWindow.isVisible || settingsWindow.isVisible {
            return false
        } else {
            return true
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        if noNecessaryWindows {
            NSApp.setActivationPolicy(.accessory)
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if noNecessaryWindows {
            mainWindowController.showWindow(self)
        } else {
            NSApp.activate(ignoringOtherApps: false)
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
