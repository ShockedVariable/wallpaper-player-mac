//
//  Status.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//

import Cocoa

extension NSMenu {
    static func dockMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu {
            NSMenuItem(localizedTitle: "Wallpaper Explorer",
                       systemImage: "photo",
                       target: delegate.mainWindowController,
                       action: #selector(delegate.mainWindowController.showWindow(_:)),
                       keyEquivalent: "")
        }
    }
    
    static func statusMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu {
            NSMenuItem(localizedTitle: "Wallpaper Explorer", 
                       systemImage: "photo",
                       target: delegate.mainWindowController,
                       action: #selector(delegate.mainWindowController.showWindow(_:)),
                       keyEquivalent: "")
            NSMenuItem(localizedTitle: "Settings", 
                       systemImage: "gearshape.fill",
                       target: delegate.settingsWindowController,
                       action: #selector(delegate.settingsWindowController.showWindow(_:)),
                       keyEquivalent: ",")
            NSMenuItem.separator()
            NSMenuItem(localizedTitle: "Quit",
                       systemImage: "power",
                       action: #selector(NSApplication.terminate(_:)),
                       keyEquivalent: "q")
        }
    }
}

extension NSImage {
    func withTemplateConfiguration(_ isTemplate: Bool = true) -> Self {
        self.isTemplate = isTemplate
        return self
    }
}
