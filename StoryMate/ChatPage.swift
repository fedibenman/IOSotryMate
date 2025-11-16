//
//  ChatPage.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import SwiftUI





class MockChatViewModel: ObservableObject {
    @Published var conversations: [Conversation] = [
        Conversation(id: "1", title: "Quest: Pixel Village"),
        Conversation(id: "2", title: "Mystery Cave"),
        Conversation(id: "3", title: "Battle of Fedi"),
        Conversation(id: "4", title: "Travel to Zone X")
    ]
    
    @Published var selectedConversation: Conversation? = nil
    @Published var messages: [Message] = [
        Message(id: "1", conversationId: "1", senderId: "ai", content: "Hello traveler! How can I help you today?"),
        Message(id: "2", conversationId: "1", senderId: "user", content: "I'm Fedi, and I'm ready to save the Pixel Realm!")
    ]
    
    @Published var messageInput: String = ""
    
    init() {
        selectedConversation = conversations.first
    }
    
    func sendMessage(userId: String) {
        guard !messageInput.isEmpty, let conversation = selectedConversation else { return }
        let msg = Message(id: UUID().uuidString, conversationId: conversation.id, senderId: userId, content: messageInput)
        messages.append(msg)
        messageInput = ""
    }
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversation = conversation
    }
}

// MARK: - Chat Bubbles
struct ChatBubbleLeft: View {
    let text: String
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Image("container")
                    .resizable()
                    .scaledToFit()
            
                    .frame(minWidth: 50, maxWidth: 290) // max width for
                    .fixedSize(horizontal: false, vertical: true)
                Text(text)
                    .padding(12)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true) // allows line wrap
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ChatBubbleRight: View {
    let text: String
    var body: some View {
        HStack {
            Spacer()
            ZStack(alignment: .trailing) {
                Image("container")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 50, maxWidth: 290)
                    .fixedSize(horizontal: false, vertical: true)
                Text(text)
                    .padding(12)
                    .foregroundColor(.black) // text color
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Drawer

struct DrawerContent: View {
    let conversations: [Conversation]
    let onConversationClick: (Conversation) -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image("x_icon")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
            }
            .padding(.bottom, 12)
            
            Text("HISTORY")
                .font(.system(size: 18, weight: .bold))
                .padding(.vertical, 8)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(conversations) { conv in
                        Button(action: { onConversationClick(conv) }) {
                            ZStack {
                                Image("container")
                                    .resizable()
                                    .frame(height: 60)
                                    .cornerRadius(8)
                                Text(conv.title)
                                    .foregroundColor(.black)
                                    .padding(.leading, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(width: 260)
        .padding(16)
        .background(Color(red: 254/255, green: 238/255, blue: 176/255))
    }
}


struct ChatPageWithDrawer: View {
    @ObservedObject var viewModel: MockChatViewModel
    let userId: String
    
    @State private var showDrawer: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            ChatPage(viewModel: viewModel, userId: userId, onMenuClick: {
                withAnimation { showDrawer.toggle() }
            })
            
            if showDrawer {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation { showDrawer = false }
                    }
                
                DrawerContent(conversations: viewModel.conversations,
                              onConversationClick: { conv in
                                  viewModel.selectConversation(conv)
                                  withAnimation { showDrawer = false }
                              },
                              onClose: { withAnimation { showDrawer = false } })
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: showDrawer)
    }
}

// MARK: - Chat Page (Main)

import SwiftUI

struct ChatPage: View {
    @ObservedObject var viewModel: MockChatViewModel
    let userId: String
    let onMenuClick: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: - Background
            Image("background_general")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                // MARK: - Top Bar (Fully Transparent)
                HStack {
                    Button(action: onMenuClick) {
                        Image("burger_icon")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    
                    Spacer()
                    Text(viewModel.selectedConversation?.title ?? "NEW QUEST")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 16)
                .background(Color.clear)
                
                // MARK: - Chat Scroll
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.messages) { msg in
                                if msg.senderId == userId {
                                    ChatBubbleRight(text: msg.content)
                                } else {
                                    ChatBubbleLeft(text: msg.content)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // MARK: - Input Bar
                ZStack {
                    // Background container image
                    Image("container")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 360, height: 55)
                     	   .clipped()
                      
                    
                    HStack(spacing: 12) {
                        
                        // Camera Button
                        Button(action: { print("Camera tapped") }) {
                            Image("add_image_button")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        
                        // Input Field + Border
                        TextField("Type your message…", text: $viewModel.messageInput)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.45), lineWidth: 1)
                            )
                        
                        // Send
                        Button(action: { viewModel.sendMessage(userId: userId) }) {
                            Image("send")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}





// MARK: - Previews

struct ChatPageWithDrawer_Previews: PreviewProvider {
    static var previews: some View {
        ChatPageWithDrawer(viewModel: MockChatViewModel(), userId: "user")
    }
}

struct DrawerContent_Previews: PreviewProvider {
    static var previews: some View {
        DrawerContent(conversations: MockChatViewModel().conversations,
                      onConversationClick: { _ in }, onClose: {})
    }
}
