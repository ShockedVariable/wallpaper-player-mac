//
//  AppDelegate.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/6.
//

import Cocoa
import Combine
import SwiftUI
import AVKit
import WebKit

@main
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    /// Provides the top-level entry point for the app.
    static func main() {
        NSApplication.shared.delegate = AppDelegate.shared
        NSApplication.shared.run()
    }
    
    var statusItem: NSStatusItem!

    var wallpaperWindow: NSWindow!
    
    var contentViewModel = ContentViewModel()
    var wallpaperViewModel = WallpaperViewModel()
    var globalSettingsViewModel = GlobalSettingsViewModel()
    
    var importOpenPanel: NSOpenPanel!
    
    var eventHandler: Any?
    
    static var shared = AppDelegate()
    
    // Windows
    weak var mainWindow: NSWindow?
    weak var settingsWindow: NSWindow?
    
    // MARK: Open Settings Window
    @objc func openSettingsWindow() {
        settingsWindowController.showWindow(self)
    }
    
    // MARK: Open Main Window
    @objc func openMainWindow() {
        mainWindowController.showWindow(self)
    }
    
    lazy var mainWindowController = MainWindowController()
    lazy var settingsWindowController = SettingsWindowController()
    
// MARK: - delegate methods
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.mainMenu = .mainMenu()
        
        saveCurrentWallpaper()
        AppDelegate.shared.setPlacehoderWallpaper(with: wallpaperViewModel.currentWallpaper)
        
        openMainWindow()
        
//        setWallpaperWindow()
//        
//        wallpaperWindow.orderFront(nil)
//        
//        for window in NSApp.windows {
//            if window.title == "Wallpaper" {
//                window.styleMask = [.borderless, .fullSizeContentView]
//                window.level = NSWindow.Level(Int(CGWindowLevelForKey(.desktopWindow)))
//                
//                window.setFrame(NSRect(origin: .zero,
//                                                     size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
//                                                                  height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
//                                                    ),
//                                              display: true)
//                window.isMovable = false
//                window.titlebarAppearsTransparent = true
//                window.titleVisibility = .hidden
//                window.canHide = false
//                window.collectionBehavior = .stationary
//            }
//        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if let wallpaper = UserDefaults.standard.url(forKey: "OSWallpaper") {
            try? NSWorkspace.shared.setDesktopImageURL(wallpaper, for: .main!)
        }
        
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let filesURL = try FileManager.default.contentsOfDirectory(at: cacheDirectory,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for url in filesURL {
                if url.lastPathComponent.contains("staticWP") {
                    try FileManager.default.removeItem(at: url)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        openMainWindow()
        return false
    }

// MARK: - misc methods
//    @objc func openSettingsWindow() {
//        NSApp.activate(ignoringOtherApps: true)
//        self.settingsWindow?.center()
//        self.settingsWindow?.makeKeyAndOrderFront(nil)
//    }
    
//    @objc func openMainWindow() {
//        self.mainWindowController.window?.makeKeyAndOrderFront(nil)
//        NSApp.activate(ignoringOtherApps: true)
//    }
    
    @MainActor @objc func toggleFilter() {
        self.contentViewModel.isFilterReveal.toggle()
    }
    
// MARK: Set Wallpaper Window - Most efforts
    func setWallpaperWindow() {
        self.wallpaperWindow = NSWindow()
        
        self.wallpaperWindow.styleMask = [.borderless, .fullSizeContentView]
        self.wallpaperWindow.level = NSWindow.Level(Int(CGWindowLevelForKey(.desktopWindow)))
        self.wallpaperWindow.collectionBehavior = .stationary
        
        self.wallpaperWindow.setFrame(NSScreen.main!.wallpaperFrame, display: true)
        self.wallpaperWindow.isMovable = false
        self.wallpaperWindow.titlebarAppearsTransparent = true
        self.wallpaperWindow.titleVisibility = .hidden
        self.wallpaperWindow.canHide = false
        self.wallpaperWindow.canBecomeVisibleWithoutLogin = true
        self.wallpaperWindow.isReleasedWhenClosed = false
        
        self.wallpaperWindow.contentView = NSHostingView(rootView:
            WallpaperView(viewModel: self.wallpaperViewModel)
        )
    }
    
    func windowWillClose(_ notification: Notification) {
        globalSettingsViewModel.reset()
    }
    
//    func setEventHandler() {
//        self.eventHandler = NSEvent.addGlobalMonitorForEvents(matching: .any) { [weak self] event in
//            // contentView.subviews.first -> SwiftUIView.subviews.first -> WKWebView
//            if let webview = self?.wallpaperWindow.contentView?.subviews.first?.subviews.first,
//               let frontmostApplication = NSWorkspace.shared.frontmostApplication,
//                   webview is WKWebView,
//                   frontmostApplication.bundleIdentifier == "com.apple.finder" {
//                switch event.type {
//                case .scrollWheel:
//                    webview.scrollWheel(with: event)
//                case .mouseMoved:
//                    webview.mouseMoved(with: event)
//                case .mouseEntered:
//                    webview.mouseEntered(with: event)
//                case .mouseExited:
//                    webview.mouseExited(with: event)
//
//                case .leftMouseUp:
//                    fallthrough
//                case .rightMouseUp:
//                    webview.mouseUp(with: event)
//                    
//                case .leftMouseDown:
//                    webview.mouseDown(with: event)
//    //            case .rightMouseDown:
//    //                view?.mouseDown(with: event)
//                    
//                case .leftMouseDragged:
//                    fallthrough
//                case .rightMouseDragged:
//                    webview.mouseDragged(with: event)
//                    
//                default:
//                    break
//                }
//            }
//        }
//    }
    
    func saveCurrentWallpaper() {
        var wallpaper: URL {
            var osWallpaper: URL { NSWorkspace.shared.desktopImageURL(for: .main!)! }
            if let wallpaper = UserDefaults.standard.url(forKey: "OSWallpaper") {
                if wallpaper != osWallpaper {
                    if !wallpaper.lastPathComponent.contains("staticWP") {
                        return wallpaper
                    }
                }
            }
            return osWallpaper
        }
        UserDefaults.standard.set(wallpaper, forKey: "OSWallpaper")
        print("Desktop image saved! which is located at: \(wallpaper.path())")
    }
    
    func setPlacehoderWallpaper(with wallpaper: WEWallpaper) {
        switch wallpaper.project.type {
        case "video":
            let asset = AVAsset(url: wallpaper.wallpaperDirectory.appending(component: wallpaper.project.file))
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            let time = CMTimeMake(value: 1, timescale: 1) // 第一帧的时间
            imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, _, error in
                if let error = error {
                    print(error)
                } else if let cgImage = cgImage {
                    let nsImage = NSImage(cgImage: cgImage, size: .zero)
                    if let data = nsImage.tiffRepresentation {
                        do {
                            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appending(path: "staticWP_\(wallpaper.wallpaperDirectory.hashValue).tiff")
                            try data.write(to: url, options: .atomic)
                            try NSWorkspace.shared.setDesktopImageURL(url, for: .main!)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        default:
            return
        }
    }
}
