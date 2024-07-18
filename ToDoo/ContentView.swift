//
//  ContentView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 10.07.2024.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSignUp = false

    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    if !hasSeenOnboarding {
                        OnboardingView(showSignUp: $showSignUp)
                    } else if authManager.isAuthenticated {
                        TaskListView(showSignUp: $showSignUp)
                    } else if showSignUp {
                        SignUpView(showSignUp: $showSignUp)
                    } else {
                        SignInView(showSignUp: $showSignUp)
                    }
                }
                .onAppear {
                    print("hasSeenOnboarding: \(hasSeenOnboarding)")
                    print("isAuthenticated: \(authManager.isAuthenticated)")
                    print("showSignUp: \(showSignUp)")
                }

                // Button to reset hasSeenOnboarding for testing
                if hasSeenOnboarding {
                    Button(action: {
                        hasSeenOnboarding = false
                        showSignUp = false
                        authManager.signOut()
                        print("hasSeenOnboarding reset to false")
                    }) {
                        Text("Reset Onboarding")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
        .onChange(of: authManager.isAuthenticated) {
            if !authManager.isAuthenticated {
                showSignUp = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}

