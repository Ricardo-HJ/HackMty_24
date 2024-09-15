import Foundation
import SwiftUI
import CoreData
import CryptoKit  // Importa CryptoKit

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var gptResponse: String = ""  // Almacena la respuesta de GPT para mostrar en la UI
    
    // Clave API almacenada de manera más segura
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        return key
    }
    
    // Función para hashing de contraseñas
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // Función para iniciar sesión
    func signIn() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try context.fetch(fetchRequest)
            let hashedInputPassword = hashPassword(password)
            if let user = results.first, user.password == hashedInputPassword {
                isAuthenticated = true
                print("Inicio de sesión exitoso.")
            } else {
                print("Credenciales incorrectas.")
            }
        } catch {
            print("Error al recuperar datos.")
        }
    }
    
    // Función para registrar un nuevo usuario
    func register() {
        let context = PersistenceController.shared.container.viewContext
        let newUser = User(context: context)
        newUser.email = email
        newUser.password = hashPassword(password)  // Aplica hashing a la contraseña antes de guardarla
        
        do {
            try context.save()
            print("Usuario registrado con éxito.")
        } catch let error as NSError {
            print("No se pudo guardar. \(error), \(error.userInfo)")
        }
    }
    
    // Función para enviar datos a la API de OpenAI
    func sendToOpenAI() {
        let prompt = "Describe tus prioridades financieras actuales basadas en el correo: \(email)"
        
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
                    return
                }
                
                guard let chatResponse = try? JSONDecoder().decode(ChatResponse.self, from: data) else {
                    print("Error: Couldn't decode data")
                    return
                }
                
                DispatchQueue.main.async {
                    self.gptResponse = chatResponse.choices.first?.message.content ?? "No response"
                    print("Response from GPT-3: \(self.gptResponse)")
                }
            }
            
            task.resume()
        } catch {
            print("Failed to create JSON request: \(error)")
        }
    }
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }

    struct Message: Codable {
        let content: String
    }

    let choices: [Choice]
}
