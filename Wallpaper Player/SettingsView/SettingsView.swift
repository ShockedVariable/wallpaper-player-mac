//
//  SettingsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import Cocoa
import SwiftUI

protocol SettingsPage: View {
    var viewModel: GlobalSettingsViewModel { get set }
    
    init(globalSettings: GlobalSettingsViewModel)
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: GlobalSettingsViewModel
    
    @ObservedObject var windowController: SettingsWindowController
    
    var body: some View {
        Group {
            switch windowController.tabSelection {
            case .none:
                PerformancePage(globalSettings: viewModel)
            case .performance:
                PerformancePage(globalSettings: viewModel)
            case .general:
                GeneralPage(globalSettings: viewModel)
            case .plugins:
                PluginsPage(globalSettings: viewModel)
            case .about:
                AboutUsView()
            }
        }
        .frame(minWidth: 500, minHeight: 400, maxHeight: 800)
        .overlay(alignment: .bottom) {
            HStack {
                if let savedSettings = try? JSONDecoder()
                    .decode(GlobalSettings.self,
                        from: UserDefaults.standard.data(forKey: "GlobalSettings")
                            ?? Data()), viewModel.settings != savedSettings {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(.yellow)
                    Text("Edited")
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    viewModel.save()
                    NSApp.keyWindow?.close()
                } label: {
                    Text("OK").frame(width: 50)
                }
                .buttonStyle(.borderedProminent)
                Button {
                    /*here should be a call of viewModel.reset() but I move it to the delegate */
                    NSApp.keyWindow?.close()
                } label: {
                    Text("Cancel").frame(width: 50)
                }
            }
            .padding(20)
        }
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//            .environmentObject({ () -> GlobalSettingsViewModel in 
//                let viewModel = GlobalSettingsViewModel()
//                viewModel.selection = 2
//                return viewModel
//            }())
//            .frame(width: 500, height: 600)
//    }
//}


