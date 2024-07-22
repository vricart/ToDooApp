//
//  CategoryCardView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 18.07.2024.
//

import SwiftUI

struct CategoryCardView: View {
    var category: String
    var taskCount: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(height: 100)
                .shadow(radius: 5)
            
            HStack {
                Image(TaskViewModel.imageName(for: category))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 64)
                    .padding(.leading, 32)
                
                VStack(alignment: .leading) {
                    Text(category.capitalized)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("\(taskCount) tasks")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.leading, 16)
                
                Spacer()
            }
            .padding()
        }
        .padding([.leading, .trailing], 16)
    }
}

#Preview {
    CategoryCardView(category: "Personal", taskCount: 5)
}
