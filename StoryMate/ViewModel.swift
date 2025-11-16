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
        ApiService.shared.getMessages(conversationId: conversation.id, userId: userId) { [weak self] result in
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
        guard let conv = selectedConversation else { return }
        let dto = CreateMessageDto(userId: userId, content: messageInput)
        ApiService.shared.createMessage(conversationId: conv.id, dto: dto) { [weak self] result in
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
