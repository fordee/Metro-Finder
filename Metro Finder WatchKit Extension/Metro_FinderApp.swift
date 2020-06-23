//
//  Metro_FinderApp.swift
//  Metro Finder WatchKit Extension
//
//  Created by John Forde on 24/06/20.
//

import SwiftUI

@main
struct Metro_FinderApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
