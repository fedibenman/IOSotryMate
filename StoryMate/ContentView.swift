//
//  ContentView.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        ChatPage(viewModel: MockChatViewModel(), userId: "user", onMenuClick: {})
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
