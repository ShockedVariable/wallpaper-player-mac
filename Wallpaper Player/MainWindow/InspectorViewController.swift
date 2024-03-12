//
//  PreviewViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import SwiftUI

class InspectorViewController: NSHostingController<InspectorViewController.ContentView> {
    
    @MainActor init() {
        super.init(rootView: ContentView())
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct ContentView: View {
        
        @State private var isPreviewing = true
        @State private var selection = TabSelection.info
        
        var body: some View {
            Group {
                if isPreviewing {
                    VStack(spacing: 0) {
                        Picker("Palette", selection: .constant("Wallpaper")) {
                            Image(systemName: "info.circle")
                                .tag("Wallpaper")
                            Image(systemName: "paintbrush")
                            Image(systemName: "play")
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .padding()
                        Divider()
                        Form {
                            Text("Wallpapepr title...")
                            ForEach(0..<100, id: \.self) { i in
                                Text("\(i)")
                            }
                        }
                        .formStyle(.grouped)
                        Divider()
                        HStack {
                            Button {
                                
                            } label: {
                                Text("Choose")
                                    .frame(width: 50)
                            }
                            .buttonStyle(.borderedProminent)
                            Button {
                                isPreviewing = false
                            } label: {
                                Text("Cancel")
                                    .frame(width: 50)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } else {
                    Text("Please select a wallpaper to inspect.")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    enum TabSelection: String, Codable {
        case info, properties, playback
    }
    
    struct PropertiesView: View {
        var body: some View {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
        }
    }
}
