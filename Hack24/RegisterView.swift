//
//  RegisterView.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 15/09/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("banorteLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .padding(.top, 50)
            
            TextField("Correo", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Contraseña", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Registrarse") {
                viewModel.register()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            
            Spacer()
        }
        .navigationTitle("Comienza tu registro")
    }
}
