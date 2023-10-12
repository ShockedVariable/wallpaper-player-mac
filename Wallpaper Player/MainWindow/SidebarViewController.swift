//
//  SidebarViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import SwiftUI

class SideBarViewController: NSHostingController<SideBarViewController.Content> {
    
    @MainActor init() {
        super.init(rootView: Content())
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Content: View {
        var body: some View {
            List {
                Section("Workshop") {
                    Text("Hello")
                }
                
                Section("Library") {
                    Text("Hello")
                }
                
                Section("Playlists") {
                    Text("Hello")
                }
            }
            .listStyle(.sidebar)
        }
    }
}
