//
//  MainWindowController.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//

import Cocoa
import SwiftUI

class MainWindowController: NSWindowController, NSWindowDelegate, NSToolbarDelegate {
    
    weak var multiDisplayToolbarItem: NSToolbarItem?
    weak var playbackToolbarItem: NSToolbarItem?
    
    init() {
        let window = NSWindow(contentRect: .zero,
                              styleMask: [],
                              backing: .buffered,
                              defer: false,
                              screen: .main)
        super.init(window: window)
        
        window.windowController = self
        window.delegate = self
        window.styleMask = [
            .titled,
            .resizable,
            .closable,
            .miniaturizable,
            .fullSizeContentView,
            .unifiedTitleAndToolbar,
        ]
        
        window.hasShadow = true

        // Title
        window.titleVisibility = .hidden

        // Toolbar
        window.toolbarStyle = .unified

        let toolbar = NSToolbar(identifier: "main-toolbar")
        toolbar.delegate = self
        toolbar.allowsUserCustomization = false
        toolbar.displayMode = .iconOnly
        window.toolbar = toolbar
        
        // View Controller
        window.contentViewController = SplitViewController()
        
        // Frame
        window.minSize = NSSize(width: 980, height: 580)
        
        window.setFrameUsingName("MainWindow")
        
        windowDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleSidebar,
            .multiDisplayPicker, 
            .playbackButton,
            .playingInfo,
            .togglePreview,
            .space,
            .flexibleSpace,
            .sidebarTrackingSeparator
        ]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.toggleSidebar, .sidebarTrackingSeparator, .multiDisplayPicker, .flexibleSpace, .togglePreview]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        []
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        
        switch itemIdentifier {
        case .multiDisplayPicker:
            let picker = NSPopUpButton()
            picker.addItem(withTitle: "Built-in Liquid Retina XDR Display")
            picker.addItem(withTitle: "X401R")
            
            picker.bezelStyle = .toolbar
            
            toolbarItem.view = picker
        case .togglePreview:
            toolbarItem.image = NSImage(systemSymbolName: "sidebar.trailing", accessibilityDescription: nil)
            toolbarItem.isBordered = true
            toolbarItem.action = #selector(togglePreview)
        default:
            break
        }
        
        return toolbarItem
    }
    
    override func windowDidLoad() {
        print("Hello")
    }
    
    func windowWillClose(_ notification: Notification) {
        
    }
    
    func windowDidResignKey(_ notification: Notification) {
        
    }
    
    func windowDidResignMain(_ notification: Notification) {
        
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        
    }
    
    func windowDidResize(_ notification: Notification) {
        window?.saveFrame(usingName: "MainWindow")
    }
    
    @objc func togglePreview() {
        (contentViewController as? SplitViewController)?
            .inspectorItem
            .animator()
            .isCollapsed
            .toggle()
    }
}

//class SideBarNavigation: ObservableObject {
//    @Published var navigation:
//    
//}

// All Customized Toolbar Items
extension NSToolbarItem.Identifier {
    public static let multiDisplayPicker = Self.init("multi-display-picker")
    public static let playbackButton = Self.init("playback-button")
    public static let playingInfo = Self.init("playing-info")
    public static let togglePreview = Self.init("preview-toggle")
}
