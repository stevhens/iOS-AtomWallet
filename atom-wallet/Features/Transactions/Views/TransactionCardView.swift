//
//  TransactionCardView.swift
//  atom-transaction
//
//  Created by Stevhen on 25/09/21.
//

import SwiftUI

struct TransactionCardView: View {
    @State var transaction: Transaction
    private var cardState: TransactionState
    
    init(transaction: Transaction, state: TransactionState) {
        _transaction = State(initialValue: transaction)
        self.cardState = state
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(transaction.code)
                    .fontWeight(.heavy)
                
                Spacer()
                
                Text("(\(cardState == .In ? "+" : "-")) \(transaction.nominal)")
            }
            
            Text(transaction.date.toShortString)
            Text(transaction.desc)
            Text(transaction.walletDescription)
            Text(transaction.status.rawValue)
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
        .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
        .padding(.horizontal)
        .padding(.top)
    }
}
