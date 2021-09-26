//
//  TransactionsView.swift
//  atom-transaction
//
//  Created by Stevhen on 25/09/21.
//

import SwiftUI

enum TransactionFormState: String {
    case add = "Add Transaction"
    case edit = "Edit Transaction"
}

struct TransactionsView: View {
    
    //MARK: - Variables
    @State private var searchText: String = ""
    @State private var selectedTab: String = ""
    @State private var showingAddTransactionModal: Bool = false
    @State private var showingTransactionModal: Bool = false
    @State private var tab: TransactionType = .All
    @State private var viewState: TransactionState = .In
    @State private var openFormState: TransactionFormState = .add
    @State private var transactions = Transaction.getTransactions()
    
    private enum TransactionType: String {
        case All
        case Active
        case Inactive
    }
    
    //MARK: - Main View
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.white
                    .ignoresSafeArea(.all)
                
                VStack {
                    SearchView(text: $searchText)
                        .padding(.horizontal, 8)
                    
                    headerMenu
                    
                    segmentMenu
                    
                    transactionList
                    
                    Spacer()
                }
                .onAppear() {
                    refreshPage()
                }
                .navigationTitle("Atom Transaction")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: addButton)
            }
        }
    }
}

//MARK: - View Components
extension TransactionsView {
    private var addButton: some View {
        Button(action: openNewTransactionSheet) {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(Color("dark-50"))
        }
        .sheet(isPresented: $showingAddTransactionModal, onDismiss: refreshPage) {
            TransactionFormView(showingModal: self.$showingAddTransactionModal, viewState: viewState, formState: .add)
        }
    }
    
    private var headerMenu: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("My Transactions")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            }
            
            Spacer(minLength: 15)
            
            Menu(content: {
                Button(action: { tab = .All; _ = filterResults() }) { Text("All (\(getTransactionCount(of: .All)))") }
                Button(action: { tab = .Active; _ = filterResults() }) { Text("Active (\(getTransactionCount(of: .Active)))") }
                Button(action: { tab = .Inactive; _ = filterResults() }) { Text("Inactive (\(getTransactionCount(of: .Inactive)))") }
            }) {
                Label(title: {
                    Text("\(tab.rawValue) (\(getTransactionCount(of: tab)))")
                        .foregroundColor(.white)
                }) {
                    Image(systemName: "slider.vertical.3")
                        .foregroundColor(.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color("dark-50"))
                .clipShape(Capsule())
            }
        }
        .padding()
    }
    
    private var segmentMenu: some View {
        HStack {
            Button(action: showIncomingTransactionSheet) {
                Text("Incoming")
                    .bold()
                    .opacity(viewState == .Out ? 0.2 : 1.0)
            }
            
            Spacer(minLength: 15)
            
            Button(action: showOutgoingTransactionSheet) {
                Text("Outgoing")
                    .bold()
                    .opacity(viewState == .In ? 0.2 : 1.0)
            }
        }
        .foregroundColor(.black)
        .padding(.horizontal, UIScreen.main.bounds.width / 6)
    }
    
    private var transactionList: some View {
        ScrollView {
            ForEach(filterResults(), id: \.self) { transaction in
                Menu(content: {
                    Button(action: openEditTransactionSheet) { HStack { Image(systemName: "square.and.pencil"); Text("Edit") } }
                    Button(action: {
                        toggleTransactionStatus(id: transaction.id)
                    }) {
                        HStack {
                            Image(systemName: transaction.walletState == .Active ? "multiply" : "checkmark")
                            Text(transaction.walletState == .Active ? "Disable" : "Activate")   
                        }
                    }
                }) {
                    TransactionCardView(transaction: transaction, state: viewState)
                        .sheet(isPresented: $showingTransactionModal, onDismiss: refreshPage) {
                            TransactionFormView(showingModal: self.$showingTransactionModal, viewState: viewState, formState: .edit, transaction: transaction)
                        }
                }
            }
            .padding(.bottom, 100)
        }
    }
}

//MARK: - Action
extension TransactionsView {
    private func filterResults() -> [Transaction] {
        let tempTransactions = tab != TransactionType.All ? transactions.filter { $0.status.rawValue == viewState.rawValue && $0.walletState.rawValue == tab.rawValue } : transactions.filter { $0.status.rawValue == viewState.rawValue }
        if searchText.isEmpty {
            return tempTransactions
        } else {
            return tempTransactions.filter { $0.code.localizedCaseInsensitiveContains(searchText) || $0.desc.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func getTransactionCount(of type: TransactionType) -> Int {
        switch type {
        case .All:
            return transactions.count
        case .Active:
            return transactions.filter( { $0.status == viewState && $0.walletState == .Active } ).count
        case .Inactive:
            return transactions.filter( { $0.status == viewState && $0.walletState == .Inactive } ).count
        }
    }
    
    private func showIncomingTransactionSheet() {
        viewState = .In
    }
    
    private func showOutgoingTransactionSheet() {
        viewState = .Out
    }
    
    private func openNewTransactionSheet() {
        openFormState = .add
        self.showingAddTransactionModal.toggle()
    }
    
    private func openEditTransactionSheet() {
        openFormState = .edit
        self.showingTransactionModal.toggle()
    }
    
    private func refreshPage() {
        _ = filterResults()
//        realm.objects(Transaction.self)
    }
    
    private func checkTransaction(id: String) -> Bool {
        return transactions.contains { (item) -> Bool in
            return item.walletState == .Active
        }
    }
    
    private func toggleTransactionStatus(id: String) {
        let transactionIndex = transactions.firstIndex(where: { $0.id == id } )!
        transactions[transactionIndex].walletState = transactions[transactionIndex].walletState == .Active ? .Inactive : .Active
        _ = filterResults()
    }
}
