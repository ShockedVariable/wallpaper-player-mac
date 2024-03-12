//
//  NotificationController.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/12/13.
//

import Combine
import Cocoa

import UserNotifications

final class NotificationController {
    
    private var cancellable = Set<AnyCancellable>()
    
    private init() {
//        NotificationCenter.default.publisher(for: NSApplication.didFinishLaunchingNotification)
//            .sink { [weak self] _ in self?.testNotify() }
//            .store(in: &cancellable)
    }
    
    func testNotify() {
        // MARK: Registering actions and notification types
        let defaultAction = UNNotificationAction(identifier: UUID().uuidString,
                                                 title: "Show",
                                                 options: .foreground)
        let defaultCategory = UNNotificationCategory(identifier: "default-category",
                                                     actions: [defaultAction],
                                                     intentIdentifiers: [],
                                                     hiddenPreviewsBodyPlaceholder: "Hello?",
                                                     options: [])

        // MARK: User Notification
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([defaultCategory])
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Wallpaper Player starts running"
                content.body = "Enjoy your free time!"
                content.categoryIdentifier = "default-category"
                content.sound = .defaultCritical

                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: nil)

                center.add(request) { error in
                    print(error as Any)
                }
            } else {
                print(error as Any)
            }
        }
    }
    
    static let shared = NotificationController()
}
