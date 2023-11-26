//
//  ContentViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import SwiftUI

class ContentViewController: NSHostingController<ContentViewController.ContentView> {
    
    @MainActor init() {
        super.init(rootView: ContentView())
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct ContentView: View {
        var body: some View {
            WallpaperExplorer(contentViewModel: .init(), wallpaperViewModel: .init())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
