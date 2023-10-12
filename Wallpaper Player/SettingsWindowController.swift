//
//  SettingsWindowController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/7.
//

import Cocoa
import SwiftUI

class SettingsWindowController: NSWindowController {
    
    convenience init() {
        self.init(window: NSWindow())
        let window = self.window!
        
        window.toolbarStyle = .preference
        window.contentView = NSHostingView(rootView: SettingsView(viewModel: .init()).environmentObject(GlobalSettingsViewModel()))
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
