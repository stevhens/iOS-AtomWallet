//
//  PickerFormView.swift
//  atom-wallet
//
//  Created by Stevhen on 26/09/21.
//

import SwiftUI

struct PickerFormView: View {
    
    let data: [String]
    @Binding var selection: String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Picker("Test", selection: $selection) {
                    ForEach(data, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .cornerRadius(8)
                .frame(width: geometry.size.width, height: 200)
                .clipped()
            }
        }
    }
}
