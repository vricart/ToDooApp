//
//  OnboardingView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 17.07.2024.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @Binding var showSignUp: Bool

    var body: some View {
        VStack {
            Text("ToDoo App")
                .font(.largeTitle)
                .padding()

            Button(action: {
                print("Get Started button clicked.")
                hasSeenOnboarding = true
                showSignUp = true
            }) {
                Text("Get Started")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(showSignUp: .constant(false))
}
