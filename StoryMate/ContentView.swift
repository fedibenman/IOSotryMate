//
//  ContentView.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel(userId: "yourUserId")
    private let userId = "yourUserId"

    var body: some View {
        ChatPageWithDrawer(
            viewModel: viewModel,
            userId: userId
        )
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
