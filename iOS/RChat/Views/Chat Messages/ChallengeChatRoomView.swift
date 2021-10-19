//
//  ChallengeChatRoomView.swift
//  RChat
//
//  Created by Andrew Morgan on 19/05/2021.
//

import SwiftUI

struct ChallengeChatRoomView: View {
    @EnvironmentObject var state: AppState
    
    let padding: CGFloat = 8
    
    var body: some View {
        VStack {
            ChallengeChatRoomBubblesView()
                .environment(\.realmConfiguration,
                              challengeApp.currentUser!.configuration(partitionValue: "conversation=\(state.userAppID)"))
            }
        .navigationBarTitle("Mrs Dotnet", displayMode: .inline)
        .padding(.horizontal, padding)
    }
}
