//
//  SplitViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import SwiftUI

///
/// The overall layout of this view should look like this:
///  ——————————————
/// |           |   Window Title   |            |
///  ——————————————
/// |           |                           |            |
/// |  Side  |                           |  Insp   |
/// |   bar   |       Content       |   ect    |
/// |           |         View          |    or     |
/// |           |                           |            |
///  ——————————————
///
class SplitViewController: NSSplitViewController {
    
    var sideBarItem:   NSSplitViewItem!
    var contentItem:   NSSplitViewItem!
    var inspectorItem: NSSplitViewItem!
    
    override func loadView() {
        super.loadView()
        // Side Bar View
        sideBarItem = NSSplitViewItem(
            sidebarWithViewController: SideBarViewController()
        )
        insertSplitViewItem(sideBarItem, at: 0)
        
        // Content View
        contentItem = NSSplitViewItem(
            viewController: ContentViewController()
        )
        insertSplitViewItem(contentItem, at: 1)
        
        // Inspector View
        inspectorItem = NSSplitViewItem(
            inspectorWithViewController: InspectorViewController()
        )
        insertSplitViewItem(inspectorItem, at: 2)
        
        // Disallow the inspector to have full-height space
        inspectorItem.allowsFullHeightLayout = false
        
        // Set width constraints for each split item
        sideBarItem.minimumThickness = 200
        sideBarItem.maximumThickness = 400
        
        //        inspectorItem.minimumThickness = 356
        
        splitView.autosaveName = "ContentSplitView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

struct SplitView_Preview: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> some NSViewController {
        SplitViewController()
    }  
    
    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
        
    }
}

#Preview {
    SplitView_Preview()
        .frame(width: 1067, height: 600)
}
