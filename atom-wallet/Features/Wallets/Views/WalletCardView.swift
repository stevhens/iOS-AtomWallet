//
//  WalletCardView.swift
//  atom-wallet
//
//  Created by Stevhen on 25/09/21.
//

import SwiftUI

struct WalletCardView: View {
    @State var wallet: Wallet
    
    init(wallet: Wallet) {
        _wallet = State(initialValue: wallet)
    }
    
    var body: some View {
        HStack {
            Text(wallet.image)
                .padding()
                .font(.system(size: 48))
                .frame(width: UIScreen.main.bounds.width / 3.2, height: 100, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(.black, lineWidth: 6)
                        .padding(6)
                )
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(wallet.title)
                    .fontWeight(.heavy)
                
                Text(wallet.reference)
                Text(wallet.desc)
                Text(wallet.status.rawValue)
            }
            .foregroundColor(.black)
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
        .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
        .padding(.horizontal)
        .padding(.top)
    }
}
