//
//  Menu.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//

import Cocoa

@resultBuilder
struct MenuBuilder {
    static func buildBlock(_ components: NSMenuItem...) -> [NSMenuItem] { components }
}

extension NSMenu {
    
    convenience init(title: String? = nil, @MenuBuilder _ items: () -> [NSMenuItem]) {
        if let title = title {
            self.init(title: title)
        } else {
            self.init()
        }
        self.items = items()
    }
    
    static func appMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu(title: "Wallpaper Player") {
            NSMenuItem(title: String(localized: "About Wallpaper Player"),
                       action: #selector(NSApp.orderFrontStandardAboutPanel(_:)),
                       keyEquivalent: "")
            
            NSMenuItem.separator()
            
            NSMenuItem(localizedTitle: String(localized: "Settings..."),
                       target: delegate.settingsWindowController,
                       action: #selector(delegate.settingsWindowController.showWindow(_:)),
                       keyEquivalent: ",")
            
            NSMenuItem.separator()
            
            NSMenuItem(title: String(localized: "Quit"),
                       action: #selector(NSApplication.terminate(_:)),
                       keyEquivalent: "q")
            
            NSMenuItem.separator()
            
            NSMenuItem(title: String(localized: "Hide"),
                       action: #selector(NSApplication.hide(_:)),
                       keyEquivalent: "h")
            NSMenuItem(localizedTitle: "Hide Others",
                       action: #selector(NSApplication.hideOtherApplications(_:)),
                       keyEquivalent: "h",
                       modifierMask: [.command, .option])
        }
    }
    
    static func fileMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu(title: "File") {
            NSMenuItem(localizedTitle: "Close Window", action: #selector(NSApp.keyWindow?.performClose(_:)), keyEquivalent: "w")
        }
    }
    
    static func EditMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu(title: "Edit") {
            NSMenuItem(localizedTitle: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z")
            NSMenuItem(localizedTitle: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z")
            
            NSMenuItem.separator()
            
            NSMenuItem(localizedTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
            NSMenuItem(localizedTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
            NSMenuItem(localizedTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
            NSMenuItem(localizedTitle: "Delete", action: #selector(NSText.delete(_:)), keyEquivalent: "")
            NSMenuItem(localizedTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
            
            NSMenuItem.separator()
            
            NSMenuItem(localizedTitle: "Find",
                       action: #selector(delegate.mainWindowController.performSearching(_:)),
                       keyEquivalent: "f")
        }
    }
    
    static func viewMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu(title: "View")
    }
    
    static func windowsMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu(title: "Window") {
            NSMenuItem(localizedTitle: "Minimize", action: #selector(NSApp.keyWindow?.performMiniaturize(_:)), keyEquivalent: "m")
        }
    }
    
    static func helpMenu(delegate: AppDelegate) -> NSMenu {
        NSMenu(title: "Help")
    }
}

extension NSMenuItem {
    convenience init(submenu: NSMenu) {
        self.init()
        self.submenu = submenu
    }
}

extension NSMenuItem {
    convenience init(localizedTitle: String, systemImage systemSymbolName: String? = nil, target: Any? = nil, action: Selector? = nil, keyEquivalent: String, modifierMask: NSEvent.ModifierFlags? = nil) {
        self.init(title: String(localized: .init(localizedTitle)), action: action, keyEquivalent: keyEquivalent)
        self.target = target as AnyObject?
        if let systemSymbolName = systemSymbolName {
            self.image = NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: nil)
        }
        if let modifierMask = modifierMask {
            self.keyEquivalentModifierMask = modifierMask
        }
    }
}
