//
//  SignInView.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 15/09/24.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    var onSignInSuccess: () -> Void // Callback para manejar el éxito del inicio de sesión

    var body: some View {
        NavigationView {
            VStack {
                loginForm
            }
            .navigationTitle("Inicia tu sesión")
        }
    }
    
    var loginForm: some View {
        VStack {
            TextField("Correo", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Contraseña", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            /*Button("Iniciar Sesión") {
                viewModel.signIn { success in
                    if success {
                        onSignInSuccess()  // Esto se llama si el inicio de sesión es exitoso
                        }
                    }
                }*/
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            NavigationLink("Registrarse", destination: RegisterView(viewModel: viewModel))
                .padding()
        }
    }
}

