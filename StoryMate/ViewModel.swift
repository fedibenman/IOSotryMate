//
//  ViewModel.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var selectedConversation: Conversation? = nil
    @Published var messages: [Message] = []
    @Published var messageInput: String = ""
    
    let userId: String
    
    init(userId: String) {
        self.userId = userId
        loadConversations()
    }
    func getMessages() {
        guard let convId = selectedConversation?.id else { return }
        ApiService.shared.getMessages(conversationId: convId, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let msgs):
                    self?.messages = msgs
                case .failure(let error):
                    print("Failed to load messages:", error)
                }
            }
        }
    }
    
    func loadConversations() {
        ApiService.shared.getConversations(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let convs):
                    self?.conversations = convs
                    if let last = convs.last {
                        self?.selectConversation(last)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func selectConversation(_ conversation: Conversation) {
        self.selectedConversation = conversation
        ApiService.shared.getMessages(conversationId: "691b0b4db31279c7184a2c18", userId: userId) { [weak self] result in

            DispatchQueue.main.async {
                switch result {
                case .success(let msgs):
                    self?.messages = msgs
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func sendMessage() {
//        guard let convId = selectedConversation?.id else { return } // safely unwrap
        let dto = CreateMessageDto(userId: userId, content: messageInput , sender: "user")
        ApiService.shared.createMessage(conversationId: "691b0b4db31279c7184a2c18", dto: dto) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let msg):
                    self?.messages.append(msg)
                    self?.messageInput = ""
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
