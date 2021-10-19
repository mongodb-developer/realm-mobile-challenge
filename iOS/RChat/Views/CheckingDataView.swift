//
//  CheckingDataView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/09/2021.
//

import SwiftUI
import RealmSwift

struct CheckingDataView: View {
    @EnvironmentObject var state: AppState
    
    @State private var isClicked: Bool = false
    
    var body: some View {
        Form {
            Section {
                Image("atlas-data")
                    .resizable()
            }
            Section {
                Text("Confirm that the RChat database in your Atlas collection now contains data")
                HStack {
                    Spacer()
                    Button(action: dataConfirmed) {
                        Text("Confirmed")
                    }
                    .disabled(isClicked)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Check Data", displayMode: .inline)
    }
    
    private func dataConfirmed() {
        isClicked = true
        state.app = RealmSwift.App(id: state.userAppID)
        state.checkingData = false
    }
}

struct CheckingDataView_Previews: PreviewProvider {
    static var previews: some View {
        CheckingDataView()
            .environmentObject(AppState())
    }
}
