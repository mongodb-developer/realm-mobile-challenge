//
//  AppState.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import RealmSwift
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var error: String?
    @Published var busyCount = 0
    @Published var pin = ""
    @Published var bootStrapped = false
    @Published var passCodeAccepted = false
    @Published var userAppID = userAppPrefix
    @Published var app: RealmSwift.App?
    @Published var checkingData = false

    var shouldIndicateActivity: Bool {
        get {
            return busyCount > 0
        }
        set (newState) {
            if newState {
                busyCount += 1
            } else {
                if busyCount > 0 {
                    busyCount -= 1
                } else {
                    print("Attempted to decrement busyCount below 1")
                }
            }
        }
    }

    var realmUser: RealmSwift.User?
    var user: User?

    var loggedIn: Bool {
        guard let app = app else {
            return false
        }
        return app.currentUser != nil && app.currentUser?.state == .loggedIn
    }

    init() {
        if let app = app {
            _ = app.currentUser?.logOut()
        }
    }
}
