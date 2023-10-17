//
//  WallpaperWindowController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/17.
//

import Cocoa

final class WallpaperWindowController: NSWindowController {
    
    var windows: [NSWindow]!
    
    init(wallpaper: WEWallpaper) {
        let window = NSWindow()
        
        
        
        super.init(window: window)
        
        windowDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
