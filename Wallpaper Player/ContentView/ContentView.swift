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

struct NavigationLinkContent: Hashable, RawRepresentable, Codable {
    
    init(title: String, systemImage: String, placement: NavigationLinkContentPlacement = .none) {
        self.title = title
        self.systemImage = systemImage
        self.placement = placement
    }
    
    init?(rawValue: String) {
        let decoder = JSONDecoder()
        
        if let rawValueData = rawValue.data(using: .utf8),
           let new = try? decoder.decode(Self.self, from: rawValueData) {
            self = new
        } else {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.systemImage = try container.decode(String.self, forKey: .systemImage)
        self.placement = try container.decode(NavigationLinkContentPlacement.self, forKey: .placement)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(systemImage, forKey: .systemImage)
        try container.encode(placement, forKey: .placement)
        // <and so on>
    }
    
    var rawValue: String {
        let encoder = JSONEncoder()
        
        encoder.outputFormatting = .sortedKeys
        
        do {
            let rawValueData = try encoder.encode(self)
            return String(data: rawValueData, encoding: .utf8)!
        } catch {
            print(error)
            return ""
        }
    }
    
    var title: String
    var systemImage: String
    
    var placement: NavigationLinkContentPlacement
    
    enum CodingKeys: CodingKey {
        case title
        case systemImage
        case placement
        // <all the other elements too>
    }
    
    enum NavigationLinkContentPlacement: Codable {
        case workshop
        case recent, author, album, genre, table, favorite
        case allPlaylists, playlist
        case none
    }
}

struct ContentView: View {
    @EnvironmentObject var globalSettingsViewModel: GlobalSettingsViewModel
    
    @State private var isDetailReveal = false
    
    @Namespace var detailAnimation
    
    @StateObject var viewModel = ContentViewModel()
    
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    private let workshopRows = [
        NavigationLinkContent(title: "Browse", systemImage: "square.grid.2x2", placement: .workshop)
    ]
    
    private let libraryRows = [
        NavigationLinkContent(title: "Recently Added", systemImage: "clock.fill", placement: .recent),
        NavigationLinkContent(title: "Authors", systemImage: "person.bubble.fill", placement: .author),
        NavigationLinkContent(title: "Wallpapers", systemImage: "photo.fill", placement: .table),
        NavigationLinkContent(title: "Genres", systemImage: "guitars.fill", placement: .genre),
        NavigationLinkContent(title: "Favorites", systemImage: "star.fill", placement: .favorite)
    ]
    
    var playlistRows: [NavigationLinkContent] {
//        var rows = [NavigationLinkContent(title: "Anime Waifu", systemImage: "music.note.list")]
        [NavigationLinkContent(title: "All Playlists", systemImage: "square.grid.3x3", placement: .allPlaylists)]
    }
    
    @AppStorage("ContentViewNavigator") var navigator =
    NavigationLinkContent(title: "Recently Added",
                          systemImage: "clock.fill",
                          placement: .recent)
    
    @State var isDropTargeted = false
    @State var isParseFinished = false
    @State var isFilterReveal = true
    
    @State var isDockIconHidden = false
    
    @State var project: WEProject!
    @State var projectUrl: URL!
    @State var greet: String = "Hello, world!"

    var body: some View {
        NavigationSplitView {
            List(selection: $navigator) {
                Section("Workshop") {
                    ForEach(workshopRows, id: \.title) { link in
                        NavigationLink(value: link) {
                            Label(link.title, systemImage: link.systemImage)
                        }
                    }
                }
                
                Section("Library") {
                    ForEach(libraryRows, id: \.title) { link in
                        NavigationLink(value: link) {
                            Label(link.title, systemImage: link.systemImage)
                        }
                    }
                }
                
                Section("Playlists") {
                    ForEach(playlistRows, id: \.title) { link in
                        NavigationLink(value: link) {
                            Label(link.title, systemImage: link.systemImage)
                        }
                    }
                }
                .tint(.secondary)
            }
//            .searchable(text: $greet, placement: .sidebar)
            .navigationSplitViewColumnWidth(200)
        } detail: {
            WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                .navigationTitle("")
                .background(Color(nsColor: .controlBackgroundColor))
                .overlay(alignment: .topTrailing) {
                    if isDetailReveal {
                        WallpaperPreview(contentViewModel: viewModel,
                                         wallpaperViewModel: wallpaperViewModel)
//                        .border(Color(nsColor: .separatorColor))
                        .background(.ultraThickMaterial)
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
                .frame(minWidth: 900, minHeight: 500)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Picker("Monitor", selection: .constant(0)) {
                    Text("Retina XDR Display").tag(0)
                    Text("Pro Display XDR").tag(1)
                }
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
                GeometryReader { proxy in
                    HStack(spacing: 0) {
                        GifImage(contentsOf: { (url: URL) in
                            if let selectedProject = try? JSONDecoder()
                                .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                                return url.appending(path: selectedProject.preview)
                            }
                            return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
                        }(wallpaperViewModel.currentWallpaper.wallpaperDirectory))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(1)
                        .frame(width: proxy.size.height,
                               height: proxy.size.height)
                        VStack {
                            Text(wallpaperViewModel.currentWallpaper.project.title)
                            Text("< Placeholder >")
                                .fontWeight(.light)
                                .foregroundStyle(.secondary)
                        }
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Material.ultraThin)
                    }
                }
                .frame(width: 300, height: 40)
                .border(Color(nsColor: NSColor.separatorColor))
            }
            
            ToolbarItemGroup(placement: .automatic) {
                Spacer()
                
                HStack {
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
                    
                    Button {
                        withAnimation(.spring()) {
                            isDetailReveal.toggle()
                        }
                    } label: {
                        Image(systemName: "list.bullet")
                    }
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
        .frame(width: 1000, height: 600)
        .environmentObject(GlobalSettingsViewModel())
}
