//
//  Models.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import Foundation

struct Conversation: Codable, Identifiable, Hashable {
    let id: String?
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "conversation_id"
        case title
    }
}

struct Message: Identifiable, Codable {
    let id: String?
    let conversationId: String?
    let sender: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "message_id"        // or whatever your API returns
        case conversationId = "conversation_id"
        case sender = "sender"
        case content
    }
}

struct CreateConversationDto: Codable {
    let userId: String?
    let title: String
}

struct CreateMessageDto: Codable {
    var conversationId: String = ""
    let userId: String
    let content: String
    let sender:String
}
