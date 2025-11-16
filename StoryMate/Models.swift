//
//  Models.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import Foundation

struct Conversation: Identifiable ,Codable{
    let id: String
    let title: String
}

struct Message: Identifiable ,Codable{
    let id: String
    let conversationId: String
    let senderId: String
    let content: String
}

struct CreateConversationDto: Codable {
    let userId: String
    let title: String
}

struct CreateMessageDto: Codable {
    var conversationId: String = ""
    let userId: String
    let content: String
}
