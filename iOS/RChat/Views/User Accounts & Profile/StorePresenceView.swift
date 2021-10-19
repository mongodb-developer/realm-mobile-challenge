//
//  StorePresenceView.swift
//  RChat
//
//  Created by Andrew Morgan on 04/10/2021.
//

import SwiftUI
import RealmSwift

struct StorePresenceView: View {
    @ObservedRealmObject var user: User
    
    var body: some View {
        Text("")
            .onAppear {
                $user.presenceState.wrappedValue = .onLine
            }
            .ignoresSafeArea(.all)
    }
}
