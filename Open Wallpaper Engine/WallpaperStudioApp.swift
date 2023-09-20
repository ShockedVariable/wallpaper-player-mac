//
//  WallpaperStudioApp.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/9/14.
//

import SwiftUI

@main
struct WallpaperStudioApp: App {
    
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject var globalSettings = GlobalSettingsViewModel()
    @StateObject var wallpaper = WallpaperViewModel()
    
    var body: some Scene {
        
        // Main Window, which displays all contents relative to wallpapers' playback & control
        Window("Wallpaper Studio", id: "main-window") {
            ContentView(wallpaperViewModel: wallpaper)
                .environmentObject(globalSettings)
        }
        .keyboardShortcut("1", modifiers: [.command, .shift])
        
        // Show Wiki Page on GitHub
        Window("Support Documentation", id: "support-documentation") {
            Text("Hello, world!")
        }
        .keyboardShortcut("0", modifiers: [.command, .shift])
        
        // Settings View
        Settings {
            SettingsView()
                .environmentObject(globalSettings)
        }
        
        // Status Bar Icon & Menu
        MenuBarExtra {
            Group {
                Button {
                    
                } label: {
                    Label("Show Wallpaper Studio", systemImage: "photo")
                }
                
                Text("World!")
            }
            .labelStyle(.titleAndIcon)
        } label: {
            Image(systemName: "display")
        }
    }
}
