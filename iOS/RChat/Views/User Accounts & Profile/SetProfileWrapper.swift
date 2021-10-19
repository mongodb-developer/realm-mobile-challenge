//
//  SetProfileWrapper.swift
//  RChat
//
//  Created by Andrew Morgan on 04/10/2021.
//

import SwiftUI
import RealmSwift

struct SetProfileWrapper: View {
    @ObservedResults(User.self) var users
    
    @Binding var isPresented: Bool
    
    var body: some View {
        if let user = users.first {
            SetProfileView(user: user, isPresented: $isPresented)
        }
    }
}
