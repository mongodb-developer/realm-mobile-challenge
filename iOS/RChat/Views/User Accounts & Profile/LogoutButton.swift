//
//  LogoutButton.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift
import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var state: AppState
    @Environment(\.realm) var userRealm
    
    @ObservedRealmObject var user: User
    
    var action: () -> Void = {}
    
    var body: some View {
        Button("Log Out") {
            state.shouldIndicateActivity = true
            logout()
        }
        .disabled(state.shouldIndicateActivity)
    }
    
    private func logout() {
        $user.presenceState.wrappedValue = .offLine
        action()
        challengeApp.currentUser?.functions.purgeOldMessages([AnyBSON(state.userAppID)]) { _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    state.error = "Failed to clean up old messages: \(error?.localizedDescription ?? "unkown")"
                }
                return
            }
            print("Cleanup requested - hidden")
        }
        if boothMode {
//            state.app?.currentUser?.functions.removeNewerChatMessages([]) { _, error in
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
                state.error = ("Failed to logout from Realm: \(error?.localizedDescription ?? "unkown")")
            }
        }
        state.user = nil
        state.bootStrapped = false
        state.passCodeAccepted = false
        state.shouldIndicateActivity = false
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            LogoutButton(user: .sample)
                .environmentObject(AppState())
                .previewLayout(.sizeThatFits)
                .padding()
        )
    }
}
