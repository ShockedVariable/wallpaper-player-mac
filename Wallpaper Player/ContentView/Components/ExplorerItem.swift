//
//  ExplorerItem.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/25.
//

import SwiftUI

protocol ExplorerStyle {
    
}

extension ExplorerStyle {
    static var automatic: DefaultExplorerStyle { .init() }
    
    static var labaledAlbum: LabeledAlbumExplorerStyle { .init() }
    
    static var unlabeledAlbum: UnlabeledAlbumExplorerStyle { .init() }
}

struct DefaultExplorerStyle: ExplorerStyle {
    
}

struct LabeledAlbumExplorerStyle: ExplorerStyle {
    
}

struct UnlabeledAlbumExplorerStyle: ExplorerStyle {
    
}

struct ExplorerItem: SubviewOfContentView {
    
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    @AppStorage("TestAnimates") var animates = false
    
    var wallpaper: WEWallpaper
    var index: Int
    
    @State private var itemWidth: CGFloat = .zero
    
    @State private var coverHovering: Bool = false
    
    @State private var playButtonHovering = false
    
    @State private var menuButtonHovering = false
    
    var body: some View {
        VStack {
            VStack {
                GifImage(contentsOf: { (url: URL) in
                    if let selectedProject = try? JSONDecoder()
                        .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                        return url.appending(path: selectedProject.preview)
                    }
                    return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
                }(wallpaper.wallpaperDirectory), animates: animates)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 4.0))
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 2, x: 0, y: 2)
                .selected(wallpaper.wallpaperDirectory == wallpaperViewModel.currentWallpaper.wallpaperDirectory)
                .overlay(Color(white: 0.0, opacity: coverHovering ? 0.25 : 0))
                
                // MARK: - Hovering Buttons
                .overlay(alignment: .bottom) {
                    if coverHovering {
                        HStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "play.fill")
                                    .foregroundStyle(.white)
                                    .padding(8)
                                    .frame(width: 28, height: 28)
                                    .background {
                                        if playButtonHovering {
                                            Color.red
                                        } else {
                                            Color(white: 0.5, opacity: 0.5)
                                        }
                                    }
                                    .clipShape(Circle())
                            }
                            .onHover { playButtonHovering = $0 }
                            Spacer()
//                            Button {
//                                
//                            } label: {
//                                Image(systemName: "play.fill")
//                            }
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.white)
                                    .padding(6)
                                    .frame(width: 28, height: 28)
                                    .background {
                                        if menuButtonHovering {
                                            Color.red
                                        } else {
                                            Color(white: 0.5, opacity: 0.5)
                                        }
                                    }
                                    .clipShape(Circle())
                            }
                            .onHover { menuButtonHovering = $0 }
                        }
                        .padding(8)
                        .buttonStyle(.plain)
                    }
                }
                // MARK: -
                
                .onHover { coverHovering = $0 }
            }
            .frame(height: itemWidth)
            
            VStack {
                Text(wallpaper.project.title)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("haren724")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 50, alignment: .top)
        }
        .background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
                    .onPreferenceChange(SizePreferenceKey.self) { self.itemWidth = $0.width }
            }
        }
        .onTapGesture {
            wallpaperViewModel.nextCurrentWallpaper = wallpaper
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

#Preview {
    WallpaperExplorer(contentViewModel: .init(),
                      wallpaperViewModel: .init())
    .frame(width: 800, height: 500)
}
