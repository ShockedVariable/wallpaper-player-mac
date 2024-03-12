//
//  GlobalSettingsController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/12/14.
//

import Combine
import Foundation

import WallpaperKit

final class GlobalSettingsController: ObservableObject {
    
    private(set) var settings: GlobalSettings
    
    private let jsonEncoder = JSONEncoder()
    
    @Published var currentWallpapers: [GSDisplayIdentifier : any Wallpaper] = [:]
    
    private init() {
        // Config JSON Coders
        jsonEncoder.outputFormatting = .prettyPrinted
        
        // Locate the document directory
        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = directoryURL.appending(path: "config.json")
            if let data = try? Data(contentsOf: fileURL) {
                do {
                    settings = try JSONDecoder().decode(GlobalSettings.self, from: data)
                } catch {
                    logger.warning("\(error)")
                    settings = GlobalSettings()
                    do {
                        try (try! jsonEncoder.encode(settings)).write(to: fileURL, options: .atomic)
                    } catch {
                        logger.warning("\(error)")
                    }
                }
            } else {
                settings = GlobalSettings()
                logger.warning("Config File not Found. Trying to Create New One...")
                do {
                    try (try! jsonEncoder.encode(settings)).write(to: fileURL, options: .atomic)
                } catch {
                    logger.warning("\(error)")
                }
            }
        } else {
            settings = GlobalSettings()
            logger.warning("Directory Not Found. All the Settings will be ignored after quit.")
        }
    }
    
    func manuallySave() {
        
    }
    
    private func save() {
        
    }
    
    static let shared = GlobalSettingsController()
}
