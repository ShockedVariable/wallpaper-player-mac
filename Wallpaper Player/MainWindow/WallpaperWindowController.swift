//
//  WallpaperWindowController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/17.
//

import Cocoa
import SwiftUI

import WallpaperKit

final class WallpaperWindowController: NSWindowController {
    
    var windows = Set<NSWindowController>()
    
    @Published var playbackStatus = PlaybackStatus.unknown
    
    convenience init() {
        self.init(windowNibName: "")
    }
    
    override func windowDidLoad() {
        
    }

}

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
        
        if let wallpaper = VideoWallpaper(contentsOf: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "Chainsaw Man")) {
            let statusBinding = Binding<PlaybackStatus>(get: { [weak self] in
                self?.playbackStatus ?? .unknown
            }, set: { [weak self] (newValue: PlaybackStatus) in
                self?.playbackStatus = newValue
            })
            contentViewController = NSHostingController(rootView: VideoWallpaperViewWrapper(wallpaper: wallpaper, status: statusBinding))
        }
        
        window.setFrame(NSRect(origin: .zero,
                                
                                size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
                                             height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
                               ), display: true)
        
        self.window = window
    }
}
