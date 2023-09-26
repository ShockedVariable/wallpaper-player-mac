//
//  ExplorerItem.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/25.
//

import SwiftUI

struct ExplorerItem: SubviewOfContentView {
    
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    @AppStorage("TestAnimates") var animates = false
    
    var wallpaper: WEWallpaper
    var index: Int
    
    var body: some View {
        VStack(spacing: 5) {
            GifImage(contentsOf: { (url: URL) in
                if let selectedProject = try? JSONDecoder()
                    .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                    return url.appending(path: selectedProject.preview)
                }
                return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
            }(wallpaper.wallpaperDirectory), animates: animates)
            .resizable()
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 6.0))
            .selected(wallpaper.wallpaperDirectory == wallpaperViewModel.currentWallpaper.wallpaperDirectory)
            
            VStack {
                Text(wallpaper.project.title)
                    .lineLimit(2)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("< Placeholder >")
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 150)
        .onTapGesture {
            wallpaperViewModel.nextCurrentWallpaper = wallpaper
        }
    }
}

#Preview {
    WallpaperExplorer(contentViewModel: .init(),
                      wallpaperViewModel: .init())
    .frame(width: 500, height: 600)
}
