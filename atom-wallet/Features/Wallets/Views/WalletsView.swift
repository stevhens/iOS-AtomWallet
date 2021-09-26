//
//  WalletsView.swift
//  atom-wallet
//
//  Created by Stevhen on 25/09/21.
//

import SwiftUI
import RealmSwift

enum WalletFormState: String {
    case add = "Add Wallet"
    case edit = "Edit Wallet"
    case view = "Wallet Detail"
}

struct WalletsView: View {
    
    //MARK: - Variables
    @State private var searchText: String = ""
    @State private var selectedTab: String = ""
    @State private var showingAddWalletModal: Bool = false
    @State private var showingWalletModal: Bool = false
    @State private var tab: WalletType = .All
    @State private var openFormState: WalletFormState = .view
    @State private var wallets = Wallet.getWallets()
    
    private enum WalletType: String {
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
                    
                    walletList
                    
                    Spacer()
                }
                .onAppear() {
                    refreshPage()
                }
                .navigationTitle("Atom Wallet")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: addButton)
            }
        }
    }
}

//MARK: - View Components
extension WalletsView {
    private var addButton: some View {
        Button(action: openNewWalletSheet) {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(Color("dark-50"))
        }
        .sheet(isPresented: $showingAddWalletModal, onDismiss: refreshPage) {
            WalletFormView(showingModal: self.$showingAddWalletModal, state: .add)
        }
    }
    
    private var headerMenu: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("My Wallets")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            }
            
            Spacer(minLength: 15)
            
            Menu(content: {
                Button(action: { tab = .All; _ = filterResults() }) { Text("All (\(getWalletCount(of: .All)))") }
                Button(action: { tab = .Active; _ = filterResults() }) { Text("Active (\(getWalletCount(of: .Active)))") }
                Button(action: { tab = .Inactive; _ = filterResults() }) { Text("Inactive (\(getWalletCount(of: .Inactive)))") }
            }) {
                Label(title: {
                    Text("\(tab.rawValue) (\(getWalletCount(of: tab)))")
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
    
    private var walletList: some View {
        ScrollView {
            ForEach(filterResults(), id: \.self) { wallet in
                Menu(content: {
                    Button(action: openViewWalletSheet) { HStack { Image(systemName: "magnifyingglass"); Text("Detail") } }
                    Button(action: openEditWalletSheet) { HStack { Image(systemName: "square.and.pencil"); Text("Edit") } }
                    Button(action: { toggleWalletStatus(id: wallet.id) }) { HStack { Image(systemName: wallet.status == .Active ? "multiply" : "checkmark"); Text(wallet.status == .Active ? "Disable" : "Activate") }  }
                }) {
                    WalletCardView(wallet: wallet)
                        .sheet(isPresented: $showingWalletModal, onDismiss: refreshPage) {
                            WalletFormView(showingModal: self.$showingWalletModal, state: openFormState, wallet: wallet)
                        }
                }
            }
            .padding(.bottom, 100)
        }
    }
}

//MARK: - Action
extension WalletsView {
    private func filterResults() -> [Wallet] {
        let tempWallets = tab != WalletType.All ? wallets.filter { $0.status.rawValue == tab.rawValue } : wallets
        if searchText.isEmpty {
            return tempWallets
        } else {
            return tempWallets.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.desc.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func getWalletCount(of type: WalletType) -> Int {
        switch type {
        case .All:
            return wallets.count
        case .Active:
            return wallets.filter( { $0.status == .Active } ).count
        case .Inactive:
            return wallets.filter( { $0.status == .Inactive } ).count
        }
    }
    
    private func openNewWalletSheet() {
        self.showingAddWalletModal.toggle()
        openFormState = .add
    }
    
    private func openEditWalletSheet() {
        self.showingWalletModal.toggle()
        openFormState = .edit
    }
    
    private func openViewWalletSheet() {
        self.showingWalletModal.toggle()
        openFormState = .view
    }
    
    private func refreshPage() {
        _ = filterResults()
//        realm.objects(Wallet.self)
    }
    
    private func checkWallet(id: String) -> Bool {
        return wallets.contains { (item) -> Bool in
            return item.status == .Active
        }
    }
    
    private func toggleWalletStatus(id: String) {
        let walletIndex = wallets.firstIndex(where: { $0.id == id } )!
        wallets[walletIndex].status = wallets[walletIndex].status == .Active ? .Inactive : .Active
        _ = filterResults()
    }
}
