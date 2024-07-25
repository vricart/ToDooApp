//
//  AuthManager.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 17.07.2024.
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var userName: String = "User"
    @Published var errorMessage: String = ""

    init() {
        checkAuthStatus()
    }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            self.isAuthenticated = true
            self.userName = user.displayName ?? "User"
            print("User is already authenticated: \(self.userName)")
        } else {
            self.isAuthenticated = false
            self.userName = "User"
            print("No authenticated user found")
        }
    }

    func signUp(name: String, email: String, password: String) {
        clearError()
        print("Sign Up button clicked")
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
            }
            guard let user = authResult?.user else {
                print("User creation failed: No user returned")
                return
            }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                } else {
                    print("User created and profile updated successfully")
                    self.isAuthenticated = true
                    self.userName = name
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        clearError()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
            }
            guard let user = authResult?.user else {
                print("Sign-in failed: No user returned")
                return
            }
            self.isAuthenticated = true
            self.userName = user.displayName ?? "User"
            print("User signed in successfully: \(self.userName)")
        }
    }

    func signOut() {
        clearError()
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.userName = "User"
            print("User signed out successfully")
        } catch let signOutError as NSError {
            self.errorMessage = signOutError.localizedDescription
            print("Error signing out: \(self.errorMessage)")
        }
    }

    func clearError() {
        self.errorMessage = ""
    }
}
