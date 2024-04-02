//
//  SettingsWindowController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/7.
//

import Cocoa
import SwiftUI

struct ConfigModel: Codable {
    
}

struct PlaybackConfig: Codable {
    
}

class WindowController: NSObject {
    
}

class SettingsWindowController: NSWindowController, NSToolbarDelegate, NSWindowDelegate, ObservableObject {
    
    @Published var tabSelection: SettingsTabSelestion?
    
    convenience init() {
        self.init(windowNibName: "")
    }
    
    override func loadWindow() {
        let window = NSWindow(contentRect: .zero,
                              styleMask: [.titled,
                                          .closable,
                                          .fullSizeContentView],
                              backing: .buffered,
                              defer: false)
        
        window.delegate = self
        window.title = "Settings"
        
        // Toolbar
        window.toolbarStyle = .preference
        let toolbar = NSToolbar(identifier: "settings-toolbar")
        toolbar.delegate = self
        toolbar.selectedItemIdentifier = .settingsPerformance
        window.title = "Performance"
        
        window.toolbar = toolbar
        
        self.window = window
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        
        contentViewController = NSHostingController(rootView: SettingsView(viewModel: .init(), windowController: self).environmentObject(GlobalSettingsViewModel()))
    }
    
    override func showWindow(_ sender: Any?) {
        if NSApp.activationPolicy() == .accessory {
            NSApp.activate(ignoringOtherApps: true)
        }
        if let window = window, window.isVisible {
            super.showWindow(sender)
        } else {
            window?.center()
            super.showWindow(sender)
        }
    }
}

// Extension for NSToolbar Delegate Methods
extension SettingsWindowController {
    
    @objc func switchTabSelection(_ sender: NSToolbarItem) {
        tabSelection = SettingsTabSelestion(rawValue: sender.tag)
        window?.title = sender.label
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        toolbarItem.action = #selector(switchTabSelection(_:))
        
        switch itemIdentifier {
            case .settingsPerformance:
                toolbarItem.label = "Performance"
                toolbarItem.image = NSImage(systemSymbolName: "gauge.open.with.lines.needle.33percent", accessibilityDescription: nil)
                toolbarItem.tag = SettingsTabSelestion.performance.rawValue
                
            case .settingsPrivacy:
                toolbarItem.label = "Privacy"
                toolbarItem.image = NSImage(systemSymbolName: "hand.raised", accessibilityDescription: nil)
                toolbarItem.tag = SettingsTabSelestion.privacy.rawValue
                
            case .settingsGeneral:
                toolbarItem.label = "General"
                toolbarItem.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)
                toolbarItem.tag = SettingsTabSelestion.general.rawValue
                
            case .settingsPlugins:
                toolbarItem.label = "Plugins"
                toolbarItem.image = NSImage(systemSymbolName: "puzzlepiece.extension", accessibilityDescription: nil)
                toolbarItem.tag = SettingsTabSelestion.plugins.rawValue
                
            case .settingsAbout:
                toolbarItem.label = "About"
                toolbarItem.image = NSImage(systemSymbolName: "person.3", accessibilityDescription: nil)
                toolbarItem.tag = SettingsTabSelestion.about.rawValue
                
            default:
                fatalError("Invalid Settings Toolbar Item!")
        }
        
        return toolbarItem
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.settingsAbout, .settingsGeneral, .settingsPlugins, .settingsPerformance, .settingsPrivacy]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.settingsAbout, .settingsGeneral, .settingsPlugins, .settingsPerformance, .settingsPrivacy]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.settingsPerformance, .settingsGeneral, .settingsPlugins, .settingsPrivacy, .settingsAbout]
    }
}

extension NSToolbarItem.Identifier {
    static let settingsPerformance = Self.init("settings-performance")
    static let settingsGeneral = Self.init("settings-general")
    static let settingsPlugins = Self.init("settings-plugins")
    static let settingsAbout = Self.init("settings-about")
    static let settingsPrivacy = Self.init("settings-privacy")
}

enum SettingsTabSelestion: Int {
    case performance, general, plugins, about, privacy
}
