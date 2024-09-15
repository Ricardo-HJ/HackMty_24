//
//  AuthViewModel.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 15/09/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false  // Nuevo estado para rastrear la autenticación
    
    func signIn() {
        // Simula una autenticación exitosa
        if email == "test@example.com" && password == "password123" {
            isAuthenticated = true
            print("Inicio de sesión exitoso")
        } else {
            print("Credenciales incorrectas")
        }
    }
    
    func register() {
        // Lógica para registrar
        print("Registrando al usuario con email: \(email) y contraseña: \(password)")
    }
}
