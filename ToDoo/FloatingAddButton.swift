//
//  FloatingAddButton.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 18.07.2024.
//

import SwiftUI

struct FloatingAddButton: View {
    @Binding var isPresented: Bool
    var isCentered: Bool

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    isPresented = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.secondaryGreenColor, Color.mainGreenColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                
                if isCentered {
                    Spacer()
                }
            }
            .padding(.trailing, isCentered ? 0 : 32)
        }
    }
}

#Preview {
    FloatingAddButton(isPresented: .constant(false), isCentered: false)
}
