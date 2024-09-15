//
//  ChatView.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 15/09/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel = ChatViewModel()

    var body: some View {
        VStack {
            List(chatViewModel.messages, id: \.id) { message in
                HStack {
                    if message.isFromUser {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }

            HStack {
                TextField("Type your message here...", text: $chatViewModel.newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    chatViewModel.sendMessage()
                }) {
                    Text("Send")
                }
                .padding()
            }
        }
    }
}
