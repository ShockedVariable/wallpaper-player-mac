//
//  MainWindowController.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//
import os
import Cocoa
import Combine
import SwiftUI

final class MainWindowController: NSWindowController, NSWindowDelegate, ObservableObject {
    
    // MARK: Weak Properties
    weak var multiDisplayToolbarItem: NSToolbarItem?
    weak var playbackToolbarItem: NSToolbarItem?
    weak var volumeSliderToolbarItem: NSToolbarItem?
    
    weak var mainWindowSearchField: NSSearchField?
    
    weak var wallpaperWindowController: WallpaperWindowController?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let logger = Logger(subsystem: "com.haren724.wallpaper-player", category: className())
    
    convenience init() {
        self.init(windowNibName: "")
    }
    
    // MARK: windowDidLoad
    override func windowDidLoad() {
        NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in self?.updateDisplayPickerData() }
            .store(in: &cancellables)
        
        // MARK: Playback Toolbar Item
        wallpaperWindowController?.$wallpaper
            .sink { [weak self] wallpaper in
                if wallpaper.settings.paused {
                    self?.playbackToolbarItem?.image = NSImage(systemSymbolName: "play.fill", accessibilityDescription: nil)
                } else {
                    self?.playbackToolbarItem?.image = NSImage(systemSymbolName: "pause.fill", accessibilityDescription: nil)
                }
            }
            .store(in: &cancellables)
        
        // MARK: Volume Slider
        wallpaperWindowController?.$wallpaper
            .sink { [weak self] wallpaper in
                (self?.volumeSliderToolbarItem?.view as? NSHostingView)?.rootView =
                VolumeSlider(volume: Binding<Float> {
                    wallpaper.settings.volume
                } set: { newVolume in
                    self?.wallpaperWindowController?.wallpaper.settings.volume = newVolume
                })
            }
            .store(in: &cancellables)
        
        // View Controller
        window?.contentViewController = SplitViewController()
        
        windowFrameAutosaveName = "main-window"
    }
    
    @objc func performSearching(_ sender: Any?) {
        if let searchField = NSApp.keyWindow?.contentView?.viewWithTag(NSLargeSearchField.className().hashValue) {
            window?.makeFirstResponder(searchField)
        } else {
            logger.error("SearchField not found! Find action will do nothing.")
        }
    }
    
    static let didPerformSearchingNotification = NSNotification.Name("com.haren724.did-perform-searching")
    
    #if DEBUG
    func windowDidEndLiveResize(_ notification: Notification) {
        print(window!.contentLayoutRect.size.debugDescription)
    }
    #endif
    
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
        if let wallpaperWindowController = wallpaperWindowController {
            wallpaperWindowController.wallpaper.settings.paused.toggle()
        } else {
            logger.error("Toggle playback status failed! Cannot find wallpaperWindowController binding.")
        }
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
            .volumeSlider,
            .space,
            .flexibleSpace,
            .sidebarTrackingSeparator
        ]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleSidebar,
            .sidebarTrackingSeparator, 
            .multiDisplayPicker,
            .playbackButton,
            .flexibleSpace,
            .playingInfo,
            .flexibleSpace,
            .volumeSlider,
            .space,
            .togglePreview
        ]
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
                toolbarItem.image = NSImage(systemSymbolName: "play.slash.fill", accessibilityDescription: nil)
                toolbarItem.isBordered = true
                toolbarItem.action = #selector(togglePlayback)
                playbackToolbarItem = toolbarItem
            case .volumeSlider:
                toolbarItem.view = NSHostingView(rootView: VolumeSlider(volume: .constant(0.0))) // Fix Value
                toolbarItem.isBordered = true
                volumeSliderToolbarItem = toolbarItem
            case .playingInfo:
                toolbarItem.view = NSHostingView(rootView: PlayingInfo(wallpaper: wallpaperWindowController?.wallpaper))
                toolbarItem.isBordered = true
                
            case let item:
                print("Unsupport toolbar item: \"\(item.rawValue)\"")
        }
        
        return toolbarItem
    }
}

struct PlayingInfo: View {
    
    var wallpaper: Legacy.Wallpaper?
    
    private let barHeight: CGFloat = 40.0
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                if let wallpaper = wallpaper {
                    GifImage(contentsOf: wallpaper.file.deletingLastPathComponent().appending(path: "preview.jpg"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "questionmark")
                }
            }
            .frame(width: barHeight, height: barHeight)
            VStack {
                VStack {
                    Text(wallpaper?.title ?? "Loading...")
                    Text("haren724123123")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
                .padding(.horizontal)
                
            }
            .frame(minWidth: 20, maxHeight: .infinity)
            .background(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 4.0))
        .frame(height: barHeight)
    }
}

#Preview {
    PlayingInfo()
        .padding()
}

struct VolumeSlider: View {
    
    @Binding var volume: Float
    
    var body: some View {
        Slider(value: $volume, in: 0.0...1.0) {
            Text("Volume")
        } minimumValueLabel: {
            Image(systemName: "speaker.fill")
        } maximumValueLabel: {
            Image(systemName: "speaker.3.fill")
        }
        .controlSize(.small)
        .labelsHidden()
        .tint(.secondary)
        .frame(minWidth: 120, minHeight: 40)
        
    }
}

#Preview {
    VolumeSlider(volume: .constant(1.0))
        .padding()
        .frame(width: 160, height: 80)
}

// MARK: - loadWindow
extension MainWindowController {
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
}

// All Customized Toolbar Items
extension NSToolbarItem.Identifier {
    public static let multiDisplayPicker = Self.init("multi-display-picker")
    public static let playbackButton = Self.init("playback-button")
    public static let playingInfo = Self.init("playing-info")
    public static let togglePreview = Self.init("preview-toggle")
    public static let volumeSlider = Self.init("volume-slider")
}
