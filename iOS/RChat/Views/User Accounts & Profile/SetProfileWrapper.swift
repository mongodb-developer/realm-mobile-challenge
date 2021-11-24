//
//  SetProfileWrapper.swift
//  RChat
//
//  Created by Andrew Morgan on 04/10/2021.
//

import SwiftUI
import RealmSwift

struct SetProfileWrapper: View {
    @EnvironmentObject var state: AppState
    @ObservedResults(User.self) var users
    
    @Binding var isPresented: Bool
    
    var body: some View {
        if let user = users.first {
            SetProfileView(user: user, isPresented: $isPresented)
        } else {
            VStack {
                Text("Missing user")
                Button("Go back") {
                    isPresented.toggle()
                }
                Button(action: logout) {
                    Text("Logout")
                }
            }
        }
    }
    
    private func logout() {
        state.shouldIndicateActivity = true
        if boothMode {
            state.app?.currentUser?.functions.RemoveAllData([]) { _, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        state.error = "Failed to delete all data from Atlas: \(error?.localizedDescription ?? "unkown")"
                    }
                    return
                }
                print("Cleanup requested - all data")
            }
        }
        Task { do {
                try await state.app?.currentUser?.logOut()
            } catch {
                state.shouldIndicateActivity = false
                state.error = ("Failed to logout from Realm: \(error.localizedDescription)")
            }
        }
        state.user = nil
        state.bootStrapped = false
        state.passCodeAccepted = false
        state.shouldIndicateActivity = false
    }
}
