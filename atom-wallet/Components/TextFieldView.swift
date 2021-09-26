//
//  TextFieldView.swift
//  atom-wallet
//
//  Created by Stevhen on 26/09/21.
//

import SwiftUI

struct TextFieldView: View {
    
    @State var title: String
    @Binding var status: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 11) {
                TextField("Not Set", text: $status)
                    .lineLimit(1)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 185, alignment: .trailing)
            }
            .foregroundColor(Color("dark-50"))
        }
        .font(.system(size: 17))
    }
}
