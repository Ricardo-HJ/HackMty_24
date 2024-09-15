//
//  ContentView.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 14/09/24.
//

import SwiftUI

/*struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel() // ViewModel inicializado y listo para usar
    @State private var isAuthenticated = false

    var body: some View {
        NavigationView {
            if isAuthenticated {
                HomePageView()
                    .environmentObject(viewModel)
            } else {
                SignInView(viewModel: viewModel, onSignInSuccess: {
                    isAuthenticated = true
                })
            }
        }
    }
}
*/

struct ContentView: View {
    var body: some View {
        ChatView()
    }
}
