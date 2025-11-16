//
//  StoryMateApp.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import SwiftUI

@main
struct StoryMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
