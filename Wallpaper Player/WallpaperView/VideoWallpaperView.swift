//
//  VideoWallpaperView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/13.
//

import Cocoa
import SwiftUI
import AVKit

import WallpaperKit

struct VideoWallpaperViewWrapper: View {
    
    @ObservedObject var wallpaper: VideoWallpaper
    
    private var vm: WallpaperViewModel {
        let vm = WallpaperViewModel()
        
        let wp = WEWallpaper(using: WEProject(file: wallpaper.file, preview: "preview.gif", title: wallpaper.title, type: "video"), where: wallpaper.bundleURL)
        
        vm.currentWallpaper = wp
        
        return vm
    }

    var body: some View {
        VideoWallpaperView(wallpaperViewModel: vm)
    }
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
