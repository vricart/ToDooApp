//
//  SplashScreenView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 22.07.2024.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.mainYellowColor.edgesIgnoringSafeArea(.all)
            Text("To Doo App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SplashScreenView()
}
