//
//  MainWindowController.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//

import Cocoa
import Combine
import SwiftUI

final class MainWindowController: NSWindowController, NSWindowDelegate, ObservableObject {
    
    weak var multiDisplayToolbarItem: NSToolbarItem?
    weak var playbackToolbarItem: NSToolbarItem?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isPlaying = false
    
    convenience init() {
        self.init(windowNibName: "")
    }
    
    override func loadWindow() {
        let window = NSWindow(contentRect: .zero,
                              styleMask: [
                                .titled,
                                .resizable,
                                .closable,
                                .miniaturizable,
                                .fullSizeContentView,
                                .unifiedTitleAndToolbar],
                              backing: .buffered,
                              defer: false)
        
        window.delegate = self
        
        // Title
        window.titleVisibility = .hidden
        
        // Toolbar
        window.toolbarStyle = .unified
        
        let toolbar = NSToolbar(identifier: "main-toolbar")
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        window.toolbar = toolbar
        
        window.tabbingMode = .disallowed
        
        window.minSize = NSSize(width: 1200, height: 750)
        
        self.window = window
    }
    
    // MARK: windowDidLoad
    override func windowDidLoad() {
        super.windowDidLoad()
        
        NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in self?.updateDisplayPickerData() }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: AppController.didReopenNotification)
            .sink { [weak self] _ in self?.showWindow(self) }
            .store(in: &cancellables)
        
        $isPlaying
            .sink { [weak self] isPlaying in
                if isPlaying {
                    self?.playbackToolbarItem?.image = NSImage(systemSymbolName: "pause.fill", accessibilityDescription: nil)
                } else {
                    self?.playbackToolbarItem?.image = NSImage(systemSymbolName: "play.fill", accessibilityDescription: nil)
                }
            }
            .store(in: &cancellables)
        
        // View Controller
        window?.contentViewController = SplitViewController()
        
        windowFrameAutosaveName = "main-window"
    }
    
    
    func windowDidEndLiveResize(_ notification: Notification) {
        print(window!.contentLayoutRect.size.debugDescription)
    }
    
    func updateDisplayPickerData() {
        guard let picker = multiDisplayToolbarItem?.view as? NSPopUpButton else { return }
        picker.removeAllItems()
        
        
        NSScreen.screens.forEach { screen in
            picker.addItem(withTitle: screen.localizedName)
        }
    }
    
    @objc func togglePreview() {
        (contentViewController as? SplitViewController)?
            .inspectorItem
            .animator()
            .isCollapsed
            .toggle()
    }
    
    @objc func togglePlayback() {
        isPlaying.toggle()
    }
}

// MARK: - Toolbar Delegate Methods
extension MainWindowController: NSToolbarDelegate {
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
        [.toggleSidebar, .sidebarTrackingSeparator, .multiDisplayPicker, .playbackButton, .flexibleSpace, .togglePreview]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        []
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        
        switch itemIdentifier {
            case .multiDisplayPicker:
                let picker = NSPopUpButton()
                
                picker.bezelStyle = .toolbar
                
                toolbarItem.view = picker
                
                multiDisplayToolbarItem = toolbarItem
                
                updateDisplayPickerData()
            case .togglePreview:
                toolbarItem.image = NSImage(systemSymbolName: "sidebar.trailing", accessibilityDescription: nil)
                toolbarItem.isBordered = true
                toolbarItem.action = #selector(togglePreview)
            case .playbackButton:
                toolbarItem.image = NSImage(systemSymbolName: "play.fill", accessibilityDescription: nil)
                toolbarItem.isBordered = true
                toolbarItem.action = #selector(togglePlayback)
                playbackToolbarItem = toolbarItem
            default:
                break
        }
        
        return toolbarItem
    }
}

// All Customized Toolbar Items
extension NSToolbarItem.Identifier {
    public static let multiDisplayPicker = Self.init("multi-display-picker")
    public static let playbackButton = Self.init("playback-button")
    public static let playingInfo = Self.init("playing-info")
    public static let togglePreview = Self.init("preview-toggle")
}
