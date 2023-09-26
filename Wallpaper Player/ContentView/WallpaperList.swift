//
//  WallpaperList.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/9/26.
//

import SwiftUI

struct WallpaperList: View {
    
    @Namespace private var animation
    
    @FocusState private var isSearchFocused
    
    @State private var isSearching = false
    
    private var urls: [URL] {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0],
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ) else {
            return []
        }
        return contents
    }
    
    private var allWallpapers: [WEWallpaper] {
        self.urls.map({ url in
            if let data = try? Data(contentsOf: url.appending(path: "project.json")), let project = try? JSONDecoder().decode(WEProject.self, from: data) {
                return WEWallpaper(using: project, where: url)
            } else {
                return WEWallpaper(using: .invalid, where: url)
            }
        })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Wallpapers")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                
                .overlay(alignment: .trailing) {
                    HStack {
                        Menu {
                            Text("Hello")
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                        .menuStyle(.borderlessButton)
                        .fixedSize()
                        if isSearching {
                            HStack {
                                Button {
                                    isSearching = false
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                }
                                .buttonStyle(.borderless)
                                .matchedGeometryEffect(id: "search", in: animation)
                                TextField("", text: .constant(""))
                                    .textFieldStyle(.roundedBorder)
                                    .frame(maxWidth: 150)
                            }
                        } else {
                            Button {
                                isSearching = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                            .buttonStyle(.borderless)
                            .matchedGeometryEffect(id: "search", in: animation)
                        }
                    }
                }
                .padding()
            Table(allWallpapers) {
                TableColumn("Title", value: \.project.title)
            }
        }
        .animation(.default, value: isSearching)
    }
}

#Preview {
    WallpaperList()
}
