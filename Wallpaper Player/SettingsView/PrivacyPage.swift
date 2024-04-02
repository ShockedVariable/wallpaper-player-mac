//
//  PrivacyPage.swift
//  Wallpaper Player
//
//  Created by Haren on 2024/4/2.
//

import SwiftUI

struct PrivacyPage: View {
    
    private let isInputMonitoring = Binding<Bool> {
        if IOHIDCheckAccess(kIOHIDRequestTypeListenEvent) == kIOHIDAccessTypeGranted { true }
        else { false }
    } set: { _ in
        if IOHIDCheckAccess(kIOHIDRequestTypeListenEvent) == kIOHIDAccessTypeUnknown {
            IOHIDRequestAccess(kIOHIDRequestTypeListenEvent)
        } else {
            NSWorkspace.shared.open(.inputMonitoringSystemSettings)
        }
    }
    
    private let isAccessibility = Binding<Bool> {
        if IOHIDCheckAccess(kIOHIDRequestTypePostEvent) == kIOHIDAccessTypeGranted { true }
        else { false }
    } set: { _ in
        if IOHIDCheckAccess(kIOHIDRequestTypePostEvent) == kIOHIDAccessTypeUnknown {
            IOHIDRequestAccess(kIOHIDRequestTypePostEvent)
        } else {
            NSWorkspace.shared.open(.accessibilitySystemSettings)
        }
    }
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: isInputMonitoring) {
                    Label("Input Monitoring", systemImage: "keyboard.badge.eye.fill")
                    Text("Interact with supported wallpapers. Requires system input monitoring permission.")
                    Text("Location: System Settings - Privacy & Security - Input Monitoring")
                }.onTapGesture {
                    
                }
            } footer: {
                Button("Per-Wallpaper Settings") {
                    fatalError()
                }.disabled(true)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Section {
                Toggle(isOn: isAccessibility) {
                    Label("Accessibility", systemImage: "accessibility")
                    Text("Interact with supported wallpapers. Requires system accessbility permission.")
                    Text("Location: System Settings - Privacy & Security - Accessibility")
                }
            } footer: {
                Button("Per-Wallpaper Settings") {
                    fatalError()
                }.disabled(true)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Section {
                
            } header: {
                Text("Close and reopen this app to make your settings take effect.")
                    .bold()
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    PrivacyPage()
        .frame(width: 500, height: 600)
}

extension URL {
    static var accessibilitySystemSettings: Self {
        .init(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
    }
    
    static var inputMonitoringSystemSettings: Self {
        .init(string: "x-apple.systempreferences:com.apple.preference.security?Privacy")!
    }
}
