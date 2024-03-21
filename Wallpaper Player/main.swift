//
//  main.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/10/5.
//

import Cocoa
import os

// OS Logger
extension Logger {
    static let shared = Logger(subsystem: "com.haren724.wallpaper-player", category: "general")
}

do {
    let delegate = AppDelegate()
    NSApplication.shared.delegate = delegate
    
    NSApplication.shared.run()
}
