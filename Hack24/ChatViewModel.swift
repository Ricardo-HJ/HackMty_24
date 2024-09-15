//
//  ChatViewModel.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 15/09/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var newMessage: String = ""

    func sendMessage() {
        let message = ChatMessage(text: newMessage, isFromUser: true)
        messages.append(message)
        fetchResponse(for: newMessage)
        newMessage = ""
    }

    func fetchResponse(for input: String) {
        let message = ChatMessage(text: input, isFromUser: true)
        // Correctamente creando un APICaller.Message con los parámetros adecuados
        let apiMessage = APICaller.Message(role: message.isFromUser ? "user" : "system", content: message.text)
        APICaller.shared.getGPTResponse(messages: [apiMessage]) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let responseMessage = ChatMessage(text: response, isFromUser: false)
                    self?.messages.append(responseMessage)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}

// Estructura que define los mensajes en el chat
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
}
