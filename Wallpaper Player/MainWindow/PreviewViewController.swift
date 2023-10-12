//
//  PreviewViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import SwiftUI

class PreviewViewController: NSHostingController<PreviewViewController.ContentView> {
    
    @MainActor init() {
        super.init(rootView: ContentView())
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct ContentView: View {
        var body: some View {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
        }
    }
}
