//
//  SidebarViewController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/12.
//

import Cocoa
import Combine
import SwiftUI

class SideBarViewController: NSHostingController<SideBarViewController.Content> {
    
    convenience init() {
        self.init(rootView: Content())
    }
    
    struct Content: View {
        
        @State private var searchText = ""
        
        @State private var selection = UserDefaults.standard.string(forKey: "Selection") ?? "recent"
        
        var body: some View {
            List(selection: $selection) {
                SearchField("Search", text: $searchText)
//                Section("Workshop") {
//                    Label("Browse", systemImage: "square.grid.2x2").tag("browse")
//                        .disabled(true)
//                }
                
                Section("Library") {
                    Label("Recently Added", systemImage: "clock.fill").tag("recent")
//                    Label("Wallpapers", systemImage: "photo.fill").tag("wallpapers")
                    Text(searchText)
                }
                
//                Section("Playlists") {
//                    Label("All Playlists", systemImage: "square.grid.3x3").tag("playlists")
//                        .disabled(true)
//                }
//                .tint(.secondary)
            }
            .listStyle(.sidebar)
            .onChange(of: selection) { newSelection in
                UserDefaults.standard.setValue(newSelection, forKey: "Selection")
            }
            .onAppear {
                selection = "recent"
            }
        }
    }
}

struct SearchField: NSViewRepresentable {
    
    @Binding private var searchText: String
    private var titleKey: String
    
    private var focused = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ titleKey: String, text: Binding<String>) {
        self.titleKey = titleKey
        self._searchText = text
        
        NotificationCenter.default.publisher(for: NSSearchField.textDidChangeNotification)
            .sink { [self] notification in
                let textView = notification.userInfo!["NSFieldEditor"] as! NSTextView
                searchText = textView.string
            }
            .store(in: &cancellables)
    }
    
    func makeNSView(context: Context) -> NSSearchField {
        let searchField = NSLargeSearchField(frame: .zero)
        searchField.placeholderString = titleKey
        searchField.bezelStyle = .roundedBezel
        searchField.controlSize = .large
        searchField.lineBreakMode = .byTruncatingHead
        
        return searchField
    }
    
    func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = searchText
    }
}

final class NSLargeSearchField: NSSearchField {
    
    override var tag: Int {
        get {
            className.hashValue
        }
        set {
            
        }
    }
    
    override func drawFocusRingMask() {
        NSBezierPath(roundedRect: bounds, xRadius: 6.0, yRadius: 6.0).fill()
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: NSView.noIntrinsicMetric, height: 30)
    }
}

#Preview {
    SideBarViewController.Content()
        .frame(width: 250, height: 600)
}

class NavigationLinkController: ObservableObject {
    
}
