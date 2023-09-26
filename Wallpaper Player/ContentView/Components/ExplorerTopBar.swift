//
//  ExplorerTopBar.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct ExplorerTopBar: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    
    @EnvironmentObject var globalSettingsViewModel: GlobalSettingsViewModel
    
    init(contentViewModel viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 160)
            Button {
                viewModel.isFilterReveal.toggle()
            } label: {
                Label("Filter Results", systemImage: "checklist.checked")
            }
            .buttonStyle(.borderedProminent)
            if globalSettingsViewModel.settings.autoRefresh {
                Button {
                    viewModel.refresh()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
            }
            Spacer()
            Button { 
                if viewModel.sortingSequence == .decrease {
                    viewModel.sortingSequence = .increase
                } else {
                    viewModel.sortingSequence = .decrease
                }
            } label: {
                Image(systemName: viewModel.sortingSequence == .increase ?
                      "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
            }
            .buttonStyle(.plain)
            Picker("Sort By", selection: $viewModel.sortingBy) {
                ForEach(WEWallpaperSortingMethod.allCases) { method in
                    Text(method.rawValue).tag(method.rawValue)
                }
            }
            .labelsHidden()
            .frame(width: 160)
        }
    }
}
