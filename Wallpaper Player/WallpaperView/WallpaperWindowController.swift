//
//  WallpaperWindowController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/2.
//

import Cocoa

class WallpaperWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let window = self.window {
            window.level = NSWindow.Level(Int(CGWindowLevelForKey(.desktopWindow)))
            window.collectionBehavior = .stationary
            
            window.setFrame(NSRect(origin: .zero,
                                     size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
                                                  height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
                                    ),
                              display: true)
            window.isMovable = false
            window.titleVisibility = .hidden
            window.canHide = false
        }
    }
}
