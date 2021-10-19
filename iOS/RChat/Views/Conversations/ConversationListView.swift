//
//  ConversationListView
//  RChat
//
//  Created by Andrew Morgan on 25/11/2020.
//

import SwiftUI
import RealmSwift

struct ConversationListView: View {
    @EnvironmentObject var state: AppState
    @ObservedResults(User.self) var users
    @Environment(\.realm) var userRealm
    
    var isPreview = false
    
    @State private var conversation: Conversation?
    @State var showConversation = false
    @State var showChallengeConversation = false
    
    private let animationDuration = 0.5
    private let sortDescriptors = [
        SortDescriptor(keyPath: "unreadCount", ascending: false),
        SortDescriptor(keyPath: "displayName", ascending: true)
    ]
    
    var body: some View {
        VStack {
            if let user = users.first {
                if let conversations = users.first?.conversations.sorted(by: sortDescriptors) {
                    List {
                        ForEach(conversations) { conversation in
                            Button(action: {
                                self.conversation = conversation
                                showConversation.toggle()
                            }) { ConversationCardView(conversation: conversation, isPreview: isPreview) }
                        }
                        Button(action: {
                            showChallengeConversation.toggle()
                        }) { ConversationCardView(conversation: challengeConversation, isPreview: isPreview)
                        }
                    }
                }
                Spacer()
                if isPreview {
                    NavigationLink(
                        destination: ChatRoomView(user: user, conversation: conversation),
                        isActive: $showConversation) { EmptyView() }
                } else {
                    if let user = state.user {
                        NavigationLink(
                            destination: ChatRoomView(user: user, conversation: conversation)
                                .environment(\.realmConfiguration, state.app!.currentUser!.configuration(partitionValue: "user=\(user._id)")),
                            isActive: $showConversation) { EmptyView() }
                    }
                    NavigationLink(
                        destination: ChallengeChatRoomView(),
                        isActive: $showChallengeConversation) { EmptyView() }
                }
                StorePresenceView(user: user)
            }
        }
        .onAppear {
            if let user = users.first {
                state.user = user
            } else {
                print("No User in ConversationListView")
            }
        }
    }
}

struct ConversationListViewPreviews: PreviewProvider {
    
    static var previews: some View {
        Realm.bootstrap()
        
        return ConversationListView(isPreview: true)
            .environmentObject(AppState.sample)
    }
}
