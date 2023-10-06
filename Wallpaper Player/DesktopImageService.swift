//
//  DesktopImageService.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/6.
//

import Cocoa
import Combine

final class DesktopImageService {
    
    static let shared = DesktopImageService()
    
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    var wallpapers: [NSScreen: URL?] {
        NSScreen.screens.reduce(into: [NSScreen: URL?]()) { result, screen in
            let wallpaperURL = NSWorkspace.shared.desktopImageURL(for: screen)
            result[screen] = wallpaperURL
        }
    }
    
    @MainActor
    func replace(with wallpaperURL: URL, in screen: NSScreen) throws {
        try NSWorkspace.shared.setDesktopImageURL(wallpaperURL, for: screen)
    }
    
    @MainActor
    func startObserving() {
        NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { _ in }
            .store(in: &cancellables)
    }
    
    @MainActor
    func stopObserving() {
        cancellables.removeAll()
    }
}
