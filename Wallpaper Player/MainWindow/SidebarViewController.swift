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
        
        @State private var selection = UserDefaults.standard.string(forKey: "Selection") ?? "recent"
        
        var body: some View {
            List(selection: $selection) {
                Section("Workshop") {
                    Label("Browse", systemImage: "square.grid.2x2").tag("browse")
                }
                
                Section("Library") {
                    Label("Recently Added", systemImage: "clock.fill").tag("recent")
                    Label("Wallpapers", systemImage: "photo.fill").tag("wallpapers")
                }
                
                Section("Playlists") {
                    Label("All Playlists", systemImage: "square.grid.3x3").tag("playlists")
                    ForEach(0..<100, id: \.self) { index in
                        Label("Playlist \(index)", systemImage: "music.note.list").tag("playlist.\(index)")
                    }
                }
                .tint(.secondary)
            }
            .listStyle(.sidebar)
            .onChange(of: selection) { newSelection in
                UserDefaults.standard.setValue(newSelection, forKey: "Selection")
            }
        }
    }
}

class NavigationLinkController: ObservableObject {
    
}
