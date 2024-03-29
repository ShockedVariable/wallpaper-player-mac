//
//  WallpaperView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//


import Cocoa
import SwiftUI

extension Legacy {
    struct PlaybackStatus {
        var rate: Float
        var volume: Float
    }
}

/// Wallpaper View
/// - Parameter url: The URL which wallpaper is located at.
extension Legacy {
    struct WallpaperView: View {
        var wallpaper: Wallpaper
        
        var body: some View {
            switch wallpaper.type {
                case .video:
                    VideoWallpaperView(wallpaper: wallpaper)
                case .web:
                    UnsupportedWallpaperView() // WebWallpaperView(wallpaperViewModel: viewModel)
                case .scene:
                    UnsupportedWallpaperView()
                default:
                    UnsupportedWallpaperView()
            }
        }
    }
}

extension Legacy {
    struct UnsupportedWallpaperView: View {
        var body: some View {
            Text("Unsupported Wallpaper")
                .foregroundStyle(.red)
                .font(.largeTitle)
                .bold()
                .padding()
                .background(.white)
        }
    }
}
