//
//  Legacy.swift
//  Wallpaper Player
//
//  Created by Haren on 2024/3/29.
//

import Foundation

import WallpaperKit

enum Legacy { }

extension Legacy {
    struct Wallpaper {
        var title: String
        var settings: PlaybackStatus
        var url: URL
        var type: WallpaperType
        var file: URL
    }
}

extension Legacy {
    enum MultiDisplayError: LocalizedError {
        case screenExists
    }
    
    enum WallpaperError: LocalizedError {
        case invalid(Wallpaper)
        case duplicate(Wallpaper)
    }
}

extension Legacy {
    final class MultiDisplayController {
        private(set) var settings: [Screens.Info : Wallpaper] = .init()
        
        func wallpaper(for screen: Screens.Info) -> Wallpaper? {
            self.settings[screen]
        }
        
        func add(_ wallpaper: Wallpaper, for screen: Screens.Info) throws {
            guard self.settings[screen] == nil else { throw MultiDisplayError.screenExists }
            try self.set(wallpaper, for: screen)
        }
        
        func set(_ wallpaper: Wallpaper, for screen: Screens.Info) throws {
            self.settings[screen] = wallpaper
        }
    }
}
