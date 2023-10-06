//
//  MainWindowController.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//

import Cocoa
import SwiftUI

class MainWindowController: NSWindowController, NSWindowDelegate {
    
    override func loadWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 980, height: 580),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false
        )
        
        window.windowController = self
        window.delegate = self
        
        window.title = "Open Wallpaper Engine \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
        
        self.window = window
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        
    }
    
    func windowWillClose(_ notification: Notification) {
        
    }
    
    func windowDidResignKey(_ notification: Notification) {
        
    }
    
    func windowDidResignMain(_ notification: Notification) {
        
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        
    }
}
