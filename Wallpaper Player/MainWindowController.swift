//
//  MainWindowController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/3.
//

import Cocoa

class MainWindowController: NSWindowController, ObservableObject {
    
    @IBOutlet weak var playbackToolbarItem: NSToolbarItem!
    
    @Published var playRate = 1.0
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        playbackToolbarItem.image = NSImage(systemSymbolName: "play.fill", accessibilityDescription: nil)
    }
    
    @IBAction func toggleInspector(_ sender: NSToolbarItem) {
        if let viewController = self.contentViewController as? NSSplitViewController {
            viewController.splitViewItems.last?.animator().isCollapsed.toggle()
        }
    }
    
    @IBAction func togglePlayback(_ sender: NSToolbarItem) {
        
    }
}
