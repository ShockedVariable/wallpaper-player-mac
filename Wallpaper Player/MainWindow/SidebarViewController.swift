//
//  SidebarViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import SwiftUI

class SideBarViewController: NSHostingController<SideBarViewController.Content> {
    
    convenience init() {
        self.init(rootView: Content())
    }
    
    struct Content: View {
        
        @State private var selection = UserDefaults.standard.string(forKey: "Selection") ?? "recent"
        
        var body: some View {
            List(selection: $selection) {
//                Section("Workshop") {
//                    Label("Browse", systemImage: "square.grid.2x2").tag("browse")
//                        .disabled(true)
//                }
                
                Section("Library") {
                    Label("Recently Added", systemImage: "clock.fill").tag("recent")
//                    Label("Wallpapers", systemImage: "photo.fill").tag("wallpapers")
                        
                }
                
//                Section("Playlists") {
//                    Label("All Playlists", systemImage: "square.grid.3x3").tag("playlists")
//                        .disabled(true)
//                }
//                .tint(.secondary)
            }
            .listStyle(.sidebar)
            .onChange(of: selection) { newSelection in
                UserDefaults.standard.setValue(newSelection, forKey: "Selection")
            }
            .onAppear {
                selection = "recent"
            }
        }
    }
}

class NavigationLinkController: ObservableObject {
    
}
