//
//  SplitViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import SwiftUI

class SplitViewController: NSSplitViewController {
    
    var sideBarItem:   NSSplitViewItem!
    var contentItem:   NSSplitViewItem!
    var inspectorItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize & include all child view controllers
        sideBarItem = NSSplitViewItem(
            sidebarWithViewController: SideBarViewController()
        )
        addSplitViewItem(sideBarItem)
        contentItem = NSSplitViewItem(
            viewController: ContentViewController()
        )
        addSplitViewItem(contentItem)
        inspectorItem = NSSplitViewItem(
            inspectorWithViewController: NSHostingController(rootView: Text("Hello").frame(maxWidth: .infinity, maxHeight: .infinity))
        )
        addSplitViewItem(inspectorItem)
        
        // Disallow the inspector to have full-height space
        inspectorItem.allowsFullHeightLayout = false
        
        // Set width constraints for each split item
        sideBarItem.minimumThickness = 200
        sideBarItem.maximumThickness = 400
        
//        inspectorItem.minimumThickness = 356
        
        splitView.autosaveName = "ContentSplitView"
        
    }
}
