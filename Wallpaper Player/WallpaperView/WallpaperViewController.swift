//
//  WallpaperViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/2.
//

import AVKit
import Cocoa
import Combine

class WallpaperViewController: NSViewController {
    
    let viewModel = WallpaperViewModel()
    
    var currentWallpapaerDidChangeCancellable: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWallpapaerDidChangeCancellable =
        viewModel.$currentWallpaper
            .sink { [unowned self] in self.changeWallpaper(to: $0) }
        
        NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
            .sink { [unowned self] _ in
                guard let player = (self.view as! AVPlayerView).player else { return }
                
                player.seek(to: CMTime.zero)
            }
    }
    
    func changeWallpaper(to wallpaper: WEWallpaper) {
        let playerView = self.view as! AVPlayerView
        let fileURL = wallpaper.wallpaperDirectory.appending(path: wallpaper.project.file)
        
        if let player = playerView.player {
            player.replaceCurrentItem(with: AVPlayerItem(url: fileURL))
        } else {
            playerView.player = AVPlayer(url: fileURL)
        }
        
        playerView.player?.rate = viewModel.playRate
    }
}
