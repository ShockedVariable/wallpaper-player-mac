//
//  ContentView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

protocol SubviewOfContentView: View {
    var viewModel: ContentViewModel { get set }
    
//    init(contentViewModel viewModel: ContentViewModel)
}

struct ContentView: View {
    @EnvironmentObject var globalSettingsViewModel: GlobalSettingsViewModel
    
    @State private var isDetailReveal = false
    
    @Namespace var detailAnimation
    
    @StateObject var viewModel = ContentViewModel()
    
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    @State var isDropTargeted = false
    @State var isParseFinished = false
    @State var isFilterReveal = true
    
    @State var isDockIconHidden = false
    
    @State var project: WEProject!
    @State var projectUrl: URL!
    @State var greet: String = "Hello, world!"
    
    var body: some View {
        NavigationSplitView {
            List {
                Section("Workshop") {
                    NavigationLink {
                        WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                            .background(Color(nsColor: .controlBackgroundColor))
                    } label: {
                        Label("Browse", systemImage: "square.grid.2x2")
                    }
                }
                
                Section("Library") {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Label("Installed", systemImage: "square.and.arrow.down.fill")
                    }
                    NavigationLink {
                        WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                            .background(Color(nsColor: .controlBackgroundColor))
                    } label: {
                        Label("Discover", systemImage: "sparkle.magnifyingglass")
                    }
                    NavigationLink {
                        WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                            .background(Color(nsColor: .controlBackgroundColor))
                    } label: {
                        Label("Workshop", systemImage: "cloud.fill")
                    }
                }
                
                Section("Playlists") {
                    NavigationLink {
                        WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                            .background(Color(nsColor: .controlBackgroundColor))
                    } label: {
                        Label("All Playlists", systemImage: "square.grid.3x3")
                    }
                }
                .tint(.secondary)
            }
            .searchable(text: $greet, placement: .sidebar)
            
        } detail: {
            WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                .background(Color(nsColor: .controlBackgroundColor))
                .overlay(alignment: .topTrailing) {
                    if isDetailReveal {
                        WallpaperPreview(contentViewModel: viewModel,
                                         wallpaperViewModel: wallpaperViewModel)
                        .border(Color(nsColor: .separatorColor))
                        .background(Color(nsColor: NSColor.windowBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                        .padding([.vertical, .trailing])
                        .frame(maxWidth: 320)
                        .matchedGeometryEffect(id: "detail", in: detailAnimation)
                    } else {
                        Button {
                            withAnimation(.spring()) {
                                isDetailReveal = true
                            }
                            print("tapped")
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.white)
                                .padding(10)
                                .font(.title)
                                .background(Color.gray)
                                .clipShape(Circle())
                                .contentShape(Circle())
                        }
                        .offset(x: 100, y: 0)
                        .padding()
                        .buttonStyle(.plain)
                        .matchedGeometryEffect(id: "detail", in: detailAnimation)
                    }
                    
                }
        }
        .presentedWindowToolbarStyle(.unifiedCompact(showsTitle: false))
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Button {
                    
                } label: {
                    Image(systemName: "backward.fill")
                }
                Button {
                    
                } label: {
                    Image(systemName: "play.fill")
                }
                Button {
                    
                } label: {
                    Image(systemName: "forward.fill")
                }
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    VStack {
                        Spacer()
                        Text("HEllo")
                        Spacer()
                    }
                }
                .frame(width: 200)
                .border(Color(nsColor: NSColor.separatorColor))
            }
            ToolbarItem {
                Slider(value: $wallpaperViewModel.playVolume,
                       in: 0...1) {
                    Text("EHEHE")
                } minimumValueLabel: {
                    Button {
                        
                    } label: {
                        Image(systemName: "speaker.fill")
                            .imageScale(.small)
                    }
                } maximumValueLabel: {
                    Button {
                        
                    } label: {
                        Image(systemName: "speaker.wave.3.fill")
                            .imageScale(.small)
                    }
                }
                .controlSize(.mini)
                .frame(width: 110)
            }
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    withAnimation(.spring()) {
                        isDetailReveal.toggle()
                    }
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
        .navigationSplitViewStyle(.prominentDetail)
        .confirmationDialog("Unsubscribe Confirmation",
                            isPresented: $viewModel.isUnsubscribeConfirming) {
            if let url = viewModel.hoveredWallpaper?.wallpaperDirectory {
                Button("Delete Immediately", role: .destructive) {
                    try? FileManager.default.removeItem(at: url)
                    if url == wallpaperViewModel.currentWallpaper.wallpaperDirectory {
                        wallpaperViewModel.currentWallpaper = WEWallpaper(using: .invalid, where: Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!)
                    }
                    viewModel.hoveredWallpaper = nil
                }
                Button("Move to Trash") {
                    try? FileManager.default.trashItem(at: url, resultingItemURL: nil)
                    if url == wallpaperViewModel.currentWallpaper.wallpaperDirectory {
                        wallpaperViewModel.currentWallpaper = WEWallpaper(using: .invalid, where: Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!)
                    }
                    viewModel.hoveredWallpaper = nil
                }
            }
            Button("Cancel", role: .cancel) {
                viewModel.hoveredWallpaper = nil
            }
        } message: {
            Text("\(viewModel.hoveredWallpaper?.project.title ?? "invalid wallpaper")")
        }
        .alert(isPresented: $viewModel.importAlertPresented, error: viewModel.importAlertError) {
            
        }
        .sheet(isPresented: $globalSettingsViewModel.isFirstLaunch) {
            FirstLaunchView()
                .environmentObject(globalSettingsViewModel)
        }
        .sheet(isPresented: $viewModel.isDisplaySettingsReveal) {
            DisplaySettings(viewModel: viewModel)
                .padding()
                .frame(width: 520, height: 450)
        }
        .sheet(isPresented: $viewModel.isUnsafeWallpaperWarningPresented) {
            UnsafeWallpaper(wallpaper: wallpaperViewModel.nextCurrentWallpaper)
                .frame(width: 600, height: 300)
        }
    }
}

#Preview {
    ContentView(wallpaperViewModel: .init())
        .frame(width: 800)
        .environmentObject(GlobalSettingsViewModel())
}
