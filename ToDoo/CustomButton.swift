//
//  CustomButton.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 19.07.2024.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: isDisabled ? [Color.gray, Color.gray] : [Color.secondaryGreenColor, Color.mainGreenColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .disabled(isDisabled)
    }
}

#Preview {
    CustomButton(title: "Get Started", action: {}, isDisabled: true)
}

#Preview {
    CustomButton(title: "Get Started", action: {}, isDisabled: true)
}
