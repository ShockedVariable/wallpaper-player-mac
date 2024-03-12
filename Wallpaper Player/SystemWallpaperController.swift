//
//  SystemWallpaperController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/12/13.
//

import Combine
import Cocoa

final class SystemWallpaperController {
    
    private var cancellable = Set<AnyCancellable>()
    
    private init() { 
        NotificationCenter.default.publisher(for: NSApplication.didFinishLaunchingNotification)
            .sink { [weak self] _ in print("Hello") }
            .store(in: &cancellable)
    }
    
    static let shared = SystemWallpaperController()
}
