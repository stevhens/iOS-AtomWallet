//
//  TabButton.swift
//  atom-wallet
//
//  Created by Stevhen on 25/09/21.
//

import SwiftUI

struct TabButton: View {
    
    let title: String
    let image: String
    
    @Binding var selected: String

    var body: some View {
        Button(action: {
            withAnimation(.spring()) { selected = title }
        }) {
            HStack(spacing: 10) {
                Image(systemName: image)
                    .foregroundColor(.white)
                
                if selected == title {
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(
                Color.white.opacity(selected == title ? 0.08: 0)
            )
        }
    }
}
