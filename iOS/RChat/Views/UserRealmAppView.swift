//
//  UserRealmAppView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/09/2021.
//

import SwiftUI
import RealmSwift

struct UserRealmAppView: View {
    @EnvironmentObject var state: AppState
    
    @Binding var readyToBootstrap: Bool
    
    @State private var realmID = userAppPrefix
    @State private var hasSubmitted = false
    @State private var loggedIn = false
    @State private var bootstrapRequested = false
    
    var validAppID: Bool {
        if hasSubmitted { return false }
        let prefixLength = userAppPrefix.count
        if realmID.count != prefixLength + 5 { return false }
        let prefixEnd = realmID.index(realmID.startIndex, offsetBy: prefixLength - 1)
        if String(realmID[...prefixEnd]) != userAppPrefix {
            return false
        }
        return true
    }
    
    var body: some View {
        if state.checkingData {
            CheckingDataView()
        } else {
            Form {
                Section {
                    Image("realm-app-id")
                        .resizable()    
                }
                Section(footer: Text("Copy Realm App ID from the Realm UI")) {
                        TextField("Realm App ID",
                                  text: $realmID,
                                  prompt: Text("Realm App ID from your MongoDB Realm App"))
                }
                Section {
                    HStack {
                        Spacer()
                        Button(action: useAppID) {
                            Text("Submit")
                        }
                        .disabled(!validAppID)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Realm App ID", displayMode: .inline)
            .onAppear { 
                print("Existing Realm App ID = \(state.userAppID)")
                realmID = state.userAppID
            }
        }
    }
    
    private func useAppID() {
        hasSubmitted = true
        state.userAppID = realmID
        state.app = RealmSwift.App(id: realmID)
        Task { await anonymousLogin() }
    }

    private func anonymousLogin() async {
        do {
            let user = try await challengeApp.login(credentials: Credentials.anonymous)
            print("Successfully logged in as user \(user)")
            user.functions.bootstrapUserApp([AnyBSON(state.userAppID)]) { _, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        state.error = "Failed to bootstrap challenge data: \(error!.localizedDescription)"
                    }
                    return
                }
                print("Bootstrap requested")
                bootstrapRequested = true
                if loggedIn {
                    print("Bootstrap requested - setting readyToBootstrap")
                    DispatchQueue.main.async {
                        readyToBootstrap = true
                        print("Set readyToBootstrap")
                    }
                }
            }
            user.functions.fetchPIN([]) { result, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        state.error = "Failed to fetch actual PIN: \(error!.localizedDescription)"
                    }
                    return
                }
                DispatchQueue.main.async {
                    guard let result = result?.stringValue else {
                        state.error = "Retrieved PIN is missing"
                        return
                    }
                    state.pin = result
                }
            }
            await signup()
            await login(true)
        } catch {
            state.error = "RChat error: \(error.localizedDescription)"
        }
    }
    
    private func signup() async {
        do {
            _ = try await state.app!.emailPasswordAuth.registerUser(email: challengeUsername, password: challengePassword)
        } catch {
            if error.localizedDescription != "name already in use" {
                DispatchQueue.main.async {
                    state.error = "Failed to sign up \(error.localizedDescription)"
                }
            }
        }
    }

    private func login(_ finalLogin: Bool = false) async {
        DispatchQueue.main.async { state.error = nil }
        do {
        let user = try await state.app!.login(credentials: .emailPassword(email: challengeUsername, password: challengePassword))
            DispatchQueue.main.async {
                print("logged in")
                state.realmUser = user
                print("state.realmUser set? \(state.realmUser == nil ? "no" : "yes")")
                loggedIn = true
                if bootstrapRequested {
                    print("Logged in – setting readyToBootstrap = true")
                    readyToBootstrap = true
                }
            } // TODO: Should already be on main thread
        } catch {
            DispatchQueue.main.async {
                state.error = "Failed to log in with unp: \(error.localizedDescription)"
            }
        }
    }
    
    private func logout() async {
        do {
            print("Logging out. \(state.app?.currentUser != nil ? "state.app?.currentUser set" : "state.app?.currentUser not set")")
            try await state.app?.currentUser?.logOut()
        } catch {
            state.error = "Failed to logout: \(error.localizedDescription)"
        }
    }
    
}

struct UserRealmAppView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserRealmAppView(readyToBootstrap: .constant(true))
                .environmentObject(AppState())
        }
    }
}
