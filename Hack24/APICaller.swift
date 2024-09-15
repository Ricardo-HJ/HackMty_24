import Foundation

final class APICaller {
    static let shared = APICaller()

    enum Constants {
        static let key = "sk-ZZuIX5tsoQAKMnNNEdXO6eaogtzxTgSdOkV1ujZdatT3BlbkFJcRXA4qr6TixXwonUCbxvbF4Jt92hgM9JY3Pv-P6O0A"
        static let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    }

    private init() {}

    struct Message: Codable {
        let role: String
        let content: String
    }

    struct RequestBody: Codable {
        let model: String
        let messages: [Message]
    }

    struct Response: Codable {
        struct Choice: Codable {
            let message: Message
        }
        let choices: [Choice]
    }

    public func getGPTResponse(messages: [Message], completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: Constants.baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.key)", forHTTPHeaderField: "Authorization")

        let body = RequestBody(model: "gpt-3.5-turbo", messages: messages)

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(.failure(NSError(domain: "HTTPError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            do {
                let responseBody = try JSONDecoder().decode(Response.self, from: data)
                if let firstChoice = responseBody.choices.first {
                    completion(.success(firstChoice.message.content))
                } else {
                    completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No choices found in response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Función para ejecutar el ejemplo de uso
func testAPI() {
    let initialMessages: [APICaller.Message] = [
        APICaller.Message(role: "system", content: "Eres un asistente útil."),
        APICaller.Message(role: "user", content: "Hola, ¿qué puedes hacer?")
    ]

    APICaller.shared.getGPTResponse(messages: initialMessages) { result in
        switch result {
        case .success(let response):
            print("Respuesta de GPT: \(response)")
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

// Ahora, puedes llamar a `testAPI()` en el lugar adecuado dentro de tu aplicación.
