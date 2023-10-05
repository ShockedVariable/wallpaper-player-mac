//
//  WallpaperStudioApp.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/9/14.
//

import SwiftUI
import WebKit


struct WallpaperPlayerApp: App {
    
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var globalSettings = GlobalSettingsViewModel()
    @StateObject private var wallpaper = WallpaperViewModel()
    
    var body: some Scene {
        
        /// The main window, which serves all the contents relative to wallpapers' playback & control
        Window("Wallpaper Studio", id: "main-window") {
//            ContentView(wallpaperViewModel: wallpaper)
//                .environmentObject(globalSettings)
            Text("Hello, world!")
        }
        .windowStyle(.hiddenTitleBar)
        .keyboardShortcut("1", modifiers: [.command, .shift])
        
        WindowGroup("Wallpaper", id: "wallpaper-window") {
            WallpaperView(viewModel: wallpaper)
        }
        
        /// Represents wiki pages on GitHub
        Window("Support Documentation", id: "support-documentation") {
            DocsView()
        }
        .keyboardShortcut("0", modifiers: [.command, .shift])
        
        /// View that represents global settings.
        Settings {
            SettingsView()
                .environmentObject(globalSettings)
        }
        
        /// Status Bar Icon & Menu.
        StatusBar()
    }
}

struct DocsView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("Baidu", value: URL(string: "https://www.baidu.com")!)
                NavigationLink("GitHub", value: URL(string: "https://github.com/haren724/open-wallpaper-engine-mac/wiki/创意工坊")!)
            }
            .navigationDestination(for: URL.self) { url in
                DocsPageView(url: url)
            }
        } detail: {
            DocsPageView()
        }
    }
}

struct DocsPageView: NSViewRepresentable {
    
    var url: URL?
    
    func makeNSView(context: Context) -> WKWebView {
        let nsView = WKWebView()
        
        if let url = self.url {
            nsView.load(URLRequest(url: url))
        }
        
        return nsView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = self.url {
            nsView.load(URLRequest(url: url, timeoutInterval: 3))
        }
    }
}

#Preview {
    ContentView(wallpaperViewModel: WallpaperViewModel())
        .environmentObject(GlobalSettingsViewModel())
}
