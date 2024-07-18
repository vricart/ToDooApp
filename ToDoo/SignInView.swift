//
//  SignInView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 17.07.2024.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject private var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @Binding var showSignUp: Bool

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .onChange(of: email) { 
                    authManager.clearError() }

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
                print("Attempting to sign in with email: \(email)")
                authManager.signIn(email: email, password: password)
            }) {
                Text("Sign In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                authManager.clearError()
                showSignUp = true
            }) {
                Text("Don't have an account? Sign Up")
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
    SignInView(showSignUp: .constant(false))
        .environmentObject(AuthManager())
}
