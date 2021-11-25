//
//  BootView.swift
//  RChat
//
//  Created by Andrew Morgan on 20/09/2021.
//

import SwiftUI
import RealmSwift
import Network

struct BootView: View {
    @EnvironmentObject var state: AppState
    @ObservedResults(User.self) var users
    
    @Binding var readyToBootstrap: Bool
    
    @State private var counter = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.opacity(1.0)
            VStack {
                Image(systemName: "applelogo")
                    .foregroundColor(.white)
                    .font(.system(size: 128))
                Text("\(counter.description)")
                    .foregroundColor(.black)
                    .onReceive(timer) { _ in
                        counter += 1
                        if users.count > 0 {
                            DispatchQueue.main.async {
                                print("Found a user")
                                state.bootStrapped = true
                                readyToBootstrap = false
                            }
                        }
                    }
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct BootView_Previews: PreviewProvider {
    static var previews: some View {
        BootView(readyToBootstrap: .constant(true))
    }
}
