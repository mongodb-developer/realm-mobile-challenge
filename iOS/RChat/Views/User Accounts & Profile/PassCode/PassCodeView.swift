//
//  PassCodeView.swift
//  RChat
//
//  Created by Andrew Morgan on 20/09/2021.
//

import SwiftUI
import RealmSwift

struct PassCodeView: View {
    @EnvironmentObject var state: AppState
    
    @State private var pin = ""
//    @State private var pinOK = false
    @State private var badPassword = false
    
    var body: some View {
        return ZStack {
            Image("iOS15-background")
                .resizable()
            Color.black.opacity(0.85)
            VStack(spacing: 0) {
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .padding(.top, 60)
                    .offset(x: badPassword ? -30 : 0)
                    .animation(Animation.default.repeatCount(5).speed(6), value: badPassword)
                VStack {
                    Text("Enter Passccode")
                        .font(.title2)
                    VStack {
                        DigitProgressView(pin: pin, numDigits: state.pin.count)
                            .frame(maxWidth: 200, maxHeight: 10)
                            .animation(.easeInOut(duration: 0.25), value: pin)
                    }
                    .offset(x: badPassword ? -30 : 0)
                    .animation(Animation.default.repeatCount(5).speed(6), value: badPassword)
                }
                .padding([.top], 80)
                VStack {
                    HStack {
                        PassCodeButton(number: 1, action: numberTapped)
                        PassCodeButton(number: 2, action: numberTapped)
                        PassCodeButton(number: 3, action: numberTapped)
                    }
                    HStack {
                        PassCodeButton(number: 4, action: numberTapped)
                        PassCodeButton(number: 5, action: numberTapped)
                        PassCodeButton(number: 6, action: numberTapped)
                    }
                    HStack {
                        PassCodeButton(number: 7, action: numberTapped)
                        PassCodeButton(number: 8, action: numberTapped)
                        PassCodeButton(number: 9, action: numberTapped)
                    }
                    PassCodeButton(number: 0, action: numberTapped)
                }
                .padding(.top, 100)
                Spacer()
                HStack {
                    Button(action: {}) {
                        Text("Emergency")
                    }
                    Spacer()
                    if pin.count > 0 {
                        Button(action: { pin = String(pin.prefix(pin.count - 1)) }) {
                            Text("Delete")
                        }
                    } else {
                        Button(action: { pin = "" }) {
                            Text("Cancel")
                        }
                    }
                }
                .padding(32)
            }
            .foregroundColor(.white)
        }
        .ignoresSafeArea(.all)
    }
    
    private func numberTapped(number: Int) {
        pin = "\(pin)\(number)"
        checkPIN()
    }
    
    private func checkPIN() {
        if pin == state.pin {
            state.passCodeAccepted = true
        } else {
            if pin.count >= state.pin.count {
                badPassword = true
                pin = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    badPassword = false
                }
            }
        }
    }
}

struct PassCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PassCodeView()
    }
}
