//
//  VideoWallpaperView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/13.
//

import Cocoa
import Combine
import SwiftUI
import AVKit

import WallpaperKit

struct VideoWallpaperViewWrapper: View {
    
    @ObservedObject var wallpaper: VideoWallpaper
    
    @StateObject private var vm = WallpaperViewModel()
    
    @Binding private var status: PlaybackStatus
    
    init(wallpaper: VideoWallpaper, status: Binding<PlaybackStatus>) {
        self.wallpaper = wallpaper
        self._status = status
    }

    var body: some View {
        VideoWallpaperView(wallpaperViewModel: vm)
            .onChange(of: status) { newStatus in
                switch newStatus {
                    case .playing:
                        vm.playRate = vm.lastPlayRate
                    case .paused:
                        vm.lastPlayRate = vm.playRate
                        vm.playRate = 0
                    case .unknown:
                        break
                }
            }
            .onChange(of: vm.playRate) { rate in
                if rate == 0 {
                    status = .paused
                } else {
                    status = .playing
                }
            }
    }
}

enum PlaybackStatus: String, Codable {
    case playing, paused, unknown
}

struct VideoWallpaperView: NSViewRepresentable {
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    @StateObject var viewModel: VideoWallpaperViewModel
    
    init(wallpaperViewModel: WallpaperViewModel) {
        self.wallpaperViewModel = wallpaperViewModel
        self._viewModel = StateObject(wrappedValue: VideoWallpaperViewModel(wallpaper: wallpaperViewModel.currentWallpaper))
    }
    
    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        
        view.player = viewModel.player
        
        // make the video boundary extends to fit the full screen without black background border
        view.videoGravity = .resizeAspectFill
        
        // hide any unneeded ui component, we want just the video output
        view.controlsStyle = .none
        
        // make sure this video player won't show any info in the system control center
        view.updatesNowPlayingInfoCenter = false
        
        // mark the flag as unneeded, improve performance and reduce power drain
        view.allowsVideoFrameAnalysis = false
        
        return view
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        let selectedWallpaper = wallpaperViewModel.currentWallpaper
        let currentWallpaper = viewModel.currentWallpaper
        
        if selectedWallpaper.wallpaperDirectory.appending(path: selectedWallpaper.project.file) != currentWallpaper.wallpaperDirectory.appending(path: currentWallpaper.project.file) {
            viewModel.currentWallpaper = selectedWallpaper
        }
        
        viewModel.playRate = wallpaperViewModel.playRate
        viewModel.playVolume = wallpaperViewModel.playVolume
    }
}

extension Legacy {
    final class AVLoopPlayerItem: AVPlayerItem { }
}

extension Legacy {
    struct VideoWallpaperView: NSViewRepresentable {
        
        var wallpaper: Wallpaper
        
        final class Coordinator {
            var lastFile: URL?
            
            var looper: AVPlayerLooper?
        }
        
//        private var loopPlaybackCancellable = NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
//            .sink { notification in
//                (notification.object as? AVLoopPlayerItem)?.seek(to: .zero, completionHandler: nil)
//            }
        
        func makeNSView(context: Context) -> AVPlayerView {
            let view = AVPlayerView()
            
            view.player = AVQueuePlayer(items: [])
            
            // make the video boundary extends to fit the full screen without black background border
            view.videoGravity = .resizeAspectFill
            
            // hide any unneeded ui component, we want just the video output
            view.controlsStyle = .none
            
            // make sure this video player won't show any info in the system control center
            view.updatesNowPlayingInfoCenter = false
            
            // mark the flag as unneeded, improve performance and reduce power drain
            view.allowsVideoFrameAnalysis = false
            
            return view
        }
        
        func updateNSView(_ nsView: AVPlayerView, context: Context) {
            if wallpaper.file != context.coordinator.lastFile {
                context.coordinator.looper = AVPlayerLooper(player: nsView.player as! AVQueuePlayer,
                                                            templateItem: AVPlayerItem(url: wallpaper.file))
                context.coordinator.lastFile = wallpaper.file
            }
            
            if wallpaper.settings.paused {
                nsView.player?.rate = 0
            } else {
                nsView.player?.rate = wallpaper.settings.rate
            }
            
            nsView.player?.volume = wallpaper.settings.volume
        }
        
        func makeCoordinator() -> Coordinator { Coordinator() }
    }
}
