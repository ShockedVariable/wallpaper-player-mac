//
//  WallpaperWindowController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/17.
//

import Cocoa
import Combine
import SwiftUI

import WallpaperKit

final class WallpaperWindowController: NSWindowController {
    
    /// Windows that each display monitor is occupied with.
    var windows = Set<NSWindowController>()
    
    private var cancellables = Set<AnyCancellable>()
    
    var settings: Legacy.MultiDisplayController?
    
    @Published var playbackStatus = PlaybackStatus.unknown
    
    @Published var wallpaper: Legacy.Wallpaper = Legacy.Wallpaper(title: "【4K/60fps/Chainsaw Man】三鹰朝「愉快的悲伤结局」电锯人 战争恶魔 Mitaka Asa Yoru アサ",
                                                       settings: .init(rate: 1.0, volume: 1.0),
                                                       url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "Chainsaw Man"),
                                                       type: .video,
                                                       file: URL(filePath: "/Users/haren724/Library/Containers/com.haren724.wallpaper-player/Data/Documents/3012918464/小羊.mp4"))
    
    convenience init() {
        self.init(multiDisplayController: nil)
    }
    
    convenience init(multiDisplayController settings: Legacy.MultiDisplayController? = nil) {
        self.init(windowNibName: "")
        self.settings = settings
    }
    
    override func windowDidLoad() {
        contentViewController = NSHostingController(rootView: Legacy.WallpaperView(wallpaper: wallpaper))
        
        $wallpaper
            .dropFirst()
            .sink { [weak self] wallpaper in
                (self?.contentViewController as? NSHostingController)?.rootView = Legacy.WallpaperView(wallpaper: wallpaper)
            }
            .store(in: &cancellables)
        
        window?.setFrame(NSRect(origin: .zero,
                                size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
                                             height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
                               ), display: true)
    }
    
}

// MARK: - loadWindow
extension WallpaperWindowController {
    override func loadWindow() {
        let window = NSWindow(contentRect: NSRect(origin: .zero,
                                                  size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
                                                               height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
                                                 ),
                              styleMask: [.borderless],
                              backing: .buffered,
                              defer: false)
        
        // Adjust window level in case it can stay at desktop image layer
        window.level = .init(Int(CGWindowLevelForKey(.desktopWindow)))
        
        // Avoid being collasped when using mission control
        window.collectionBehavior = .stationary
        
        // Letting this window draggable isn't what we expected
        window.isMovable = false
        
        // We don't need a window title
        window.titleVisibility = .hidden
        
        // And also can't be hidden
        window.canHide = false
        
        self.window = window
    }
}
