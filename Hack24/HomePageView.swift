//
//  HomePageView.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 15/09/24.
//

import Foundation
import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel  // Asumiendo que tienes el ViewModel con datos del usuario
    @State private var userGreeting = ""
    
    var body: some View {
        VStack {
            Text(userGreeting)
                .padding()
            
            Button("Obtener Respuesta de GPT") {
                sendGreetingToGPT()
            }
        }
        .onAppear {
            userGreeting = "¡Hola, \(authViewModel.email)! ¿Cómo puedo ayudarte hoy?"
        }
    }
    
    func sendGreetingToGPT() {
        authViewModel.sendCustomPrompt(userGreeting) { response in
            self.userGreeting = response
        }
    }
}


extension AuthViewModel {
    func sendCustomPrompt(_ prompt: String, completion: @escaping (String) -> Void) {
        guard let apiKey = ProcessInfo.processInfo.environment["sk-ZZuIX5tsoQAKMnNNEdXO6eaogtzxTgSdOkV1ujZdatT3BlbkFJcRXA4qr6TixXwonUCbxvbF4Jt92hgM9JY3Pv-P6O0A"] else {
            print("API Key not set")
            completion("Failed to send data to GPT: API key not set.")
            return
        }
        
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let requestBody: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: No data to decode or an error occurred: \(error!.localizedDescription)")
                    completion("Failed to get a response from GPT.")
                    return
                }
                
                guard let chatResponse = try? JSONDecoder().decode(ChatResponse.self, from: data) else {
                    print("Error: Couldn't decode data")
                    completion("Failed to decode the response from GPT.")
                    return
                }
                
                DispatchQueue.main.async {
                    completion(chatResponse.choices.first?.message.content ?? "No response")
                }
            }
            
            task.resume()
        } catch {
            print("Failed to create JSON request: \(error)")
            completion("Failed to create request.")
        }
    }
}
