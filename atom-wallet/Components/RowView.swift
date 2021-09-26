//
//  RowView.swift
//  atom-wallet
//
//  Created by Stevhen on 26/09/21.
//

import SwiftUI

struct RowView: View {
    
    var title: String
    var status: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 11) {
                Text(status.isEmpty ? "Not Set" : status)
                    .lineLimit(1)
                    .frame(width: UIScreen.main.bounds.width / 2, alignment: .trailing)
                    .foregroundColor(status.isEmpty || status == "Not Set" ? .black.opacity(0.3) : .black)
            }
            .foregroundColor(Color("dark-50"))
        }
        .font(.system(size: 17))
    }
}
