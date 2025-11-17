//
//  ApiService.swift
//  StoryMate
//
//  Created by Apple Esprit on 16/11/2025.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    private let baseURL = "http://localhost:3001/ai-conversations"

    func getConversations(userId: String?, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "userId", value: "123e4567-e89b-12d3-a456-426614174000")]
        
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let convs = try JSONDecoder().decode([Conversation].self, from: data)
                print(convs)
                completion(.success(convs))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getMessages(conversationId: String, userId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let urlString = "\(baseURL)/\(conversationId)/messages?userId=691b0b4db31279c7184a2c18"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let messages = try JSONDecoder().decode([Message].self, from: data)
                completion(.success(messages))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func createMessage(conversationId: String, dto: CreateMessageDto, completion: @escaping (Result<Message, Error>) -> Void) {
        let urlString = "\(baseURL)/\(conversationId)/messages"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONEncoder().encode(dto)
            request.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let message = try JSONDecoder().decode(Message.self, from: data)
                completion(.success(message))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
