//
//  CustomBackgroundView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 18.07.2024.
//

import SwiftUI

struct CustomBackgroundView: View {
    var isReversed: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                Circle()
                    .fill(Color.mainYellowColor)
                    .scaleEffect(2)
                    .offset(y: isReversed ? geometry.size.height / 2 : -geometry.size.height / 2)
            }
        }
    }
    
    private var backgroundColor: Color {
        colorScheme == .light ? .white : Color(.systemBackground)
    }
}

#Preview {
    CustomBackgroundView()
        .edgesIgnoringSafeArea(.all)
}
