//
//  RChatApp.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI
import RealmSwift

let challengeApp = RealmSwift.App(id: challengeAppID)

@main
struct RChatApp: SwiftUI.App {
    @StateObject var state = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
        }
    }
}
