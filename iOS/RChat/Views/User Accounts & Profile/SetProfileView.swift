//
//  SetProfileView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import UIKit
import SwiftUI
import RealmSwift

struct SetProfileView: View {
    @EnvironmentObject var state: AppState
//    @Environment(\.realm) var userRealm
    @AppStorage("shouldShareLocation") var shouldShareLocation = false
    
    @ObservedRealmObject var user: User
    
    @Binding var isPresented: Bool

    @State private var displayName = ""
    @State private var photo: Photo?
    @State private var photoAdded = false
    
    var body: some View {
        Form {
            Section(header: Text("User Profile")) {
                if let photo = photo {
                    AvatarButton(photo: photo) {
//                        self.showPhotoTaker()
                    }
                }
                if photo == nil {
                    Button(action: { self.showPhotoTaker() }) {
                        Text("Add Photo")
                    }
                }
                InputField(title: "Display Name", text: $displayName)
//                CallToActionButton(title: "Save User Profile", action: saveProfile)
            }
            Section(header: Text("Device Settings")) {
                Toggle(isOn: $shouldShareLocation, label: {
                    Text("Share Location")
                })
                .onChange(of: shouldShareLocation) { value in
                    if value {
                        _ = LocationHelper.currentLocation
                    }
                }
                OnlineAlertSettings()
            }
        }
        .onAppear { initData() }
        .padding()
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: { isPresented = false }) { BackButton() },
            trailing: state.loggedIn ? LogoutButton(user: user, action: {
                state.error = nil
                isPresented = false
            }) : nil)
    }
    
    private func initData() {
        displayName = state.user?.userPreferences?.displayName ?? ""
        photo = state.user?.userPreferences?.avatarImage
    }
    
    private func saveProfile() {
        $user.presenceState.wrappedValue = .onLine
//        $user.userPreferences.wrappedValue!.displayName = displayName
        if photoAdded {
            guard let newPhoto = photo else {
                print("Missing photo")
                return
            }
            $user.userPreferences.wrappedValue!.avatarImage = newPhoto
        }
    }

    private func showPhotoTaker() {
        PhotoCaptureController.show(source: .camera) { controller, photo in
            self.photo = photo
            photoAdded = true
            controller.hide()
        }
    }
}

struct SetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let previewState: AppState = .sample
        return AppearancePreviews(
            NavigationView {
                SetProfileView(user: .sample, isPresented: .constant(true))
            }
        )
        .environmentObject(previewState)
    }
}
