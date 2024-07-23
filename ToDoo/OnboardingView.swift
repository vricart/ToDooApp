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
    @Binding var showOnboarding: Bool

    var body: some View {
        VStack {
            Spacer()
            
            Image("todoo-onboarding")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
                .padding()
            
            VStack(alignment: .center) {
                Text("Get Your Life Organized")
                    .font(.title2).bold()
                    .padding()
                
                Text("ToDoo is a simple and effective to-do list and task manager app which helps you manage time.")
                    .foregroundColor(Color(.darkGray))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 56)
            }
            
            Spacer()
            
            CustomButton(title: "Get Started") {
                print("Get Started button clicked.")
                hasSeenOnboarding = true
                showSignUp = true
                showOnboarding = false
            }
        }
        .padding()
    }
}

#Preview {
    OnboardingView(showSignUp: .constant(false), showOnboarding: .constant(false))
}



