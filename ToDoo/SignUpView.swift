//
//  SignUpView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 17.07.2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject private var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @Binding var showSignUp: Bool

    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .onChange(of: name) { authManager.clearError() }

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .onChange(of: email) { authManager.clearError() }

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .onChange(of: password) { authManager.clearError() }

            if !authManager.errorMessage.isEmpty {
                Text(authManager.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                print("Attempting to sign up with email: \(email)")
                authManager.signUp(name: name, email: email, password: password)
            }) {
                Text("Sign Up")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                authManager.clearError()
                showSignUp = false
            }) {
                Text("Already have an account? Sign In")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
        .onChange(of: authManager.isAuthenticated) {
            if authManager.isAuthenticated {
                dismiss()
            }
        }
    }
}

#Preview {
    SignUpView(showSignUp: .constant(true))
        .environmentObject(AuthManager())
}
