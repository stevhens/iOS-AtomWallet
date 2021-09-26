//
//  ContentView.swift
//  atom-wallet
//
//  Created by Stevhen on 25/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var current = "Wallet"
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $current) {
                WalletsView()
                    .tag("Wallet")
                
                TransactionsView()
                    .tag("Transaction")
            }
            
            HStack {
                TabButton(title: "Wallet", image: "dollarsign.square.fill", selected: $current)
                Spacer(minLength: 0)
                TabButton(title: "Transaction", image: "banknote.fill", selected: $current)
                Spacer(minLength: 0)
                TabButton(title: "Report", image: "text.book.closed.fill", selected: $current)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color("dark-50"))
            .clipShape(Capsule())
            .padding(.horizontal, 25)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
