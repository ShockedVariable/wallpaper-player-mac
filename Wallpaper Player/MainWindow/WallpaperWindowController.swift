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
    
    convenience init() {
        self.init(windowNibName: "")
    }
    
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
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let wallpaper = try? VideoWallpaper(contentsOf: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "3012918464")) {
            contentViewController = NSHostingController(rootView: VideoWallpaperViewWrapper(wallpaper: wallpaper))
        }
        
        window?.setFrame(NSRect(origin: .zero,
                                
                                size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
                                             height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
                               ), display: true)
    }

}
