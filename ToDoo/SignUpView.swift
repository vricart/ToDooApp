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
        ZStack {
            CustomBackgroundView()
                .offset(y: -250)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Let's sign up!")
                    .fontWeight(.bold)
                    .padding()
                
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

                CustomButton(title: "Sign Up") {
                    print("Attempting to sign up with email: \(email)")
                    authManager.signUp(name: name, email: email, password: password)
                }

                Button(action: {
                    authManager.clearError()
                    showSignUp = false
                }) {
                    Text("Already have an account? Sign In")
                        .foregroundColor(Color.mainGreenColor)
                }
                .padding()
            }
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
