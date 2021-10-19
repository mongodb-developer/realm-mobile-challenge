//
//  PassCodeButton.swift
//  RChat
//
//  Created by Andrew Morgan on 20/09/2021.
//

import SwiftUI

struct PassCodeButton: View {
    let number: Int
    var action: (Int) -> Void = { number in
        print("\(number)")
    }
    
    @State private var letters = ""
    
    var body: some View {
        Button(action: { action(number) }) {
            ZStack {
                Circle()
                    .opacity(0.2)
                VStack(spacing: 0) {
                    Text("\(number)")
                        .font(.system(size: 42))
                    if number != 0 {
                        Text(letters)
                            .font(.footnote)
                            .padding(.top, -8)
                    }
                }
            }
        }
        .frame(maxWidth: 80, maxHeight: 80)
        .padding(6)
        .foregroundColor(.white)
        .onAppear(perform: initLetters)
    }
    
    private func initLetters() {
        switch number {
        case 2:
            letters = "ABC"
        case 3:
            letters = "DEF"
        case 4:
            letters = "GHI"
        case 5:
            letters = "JKL"
        case 6:
            letters = "MNO"
        case 7:
            letters = "PQRS"
        case 8:
            letters = "TUV"
        case 9:
            letters = "WXYZ"
        default:
            letters = ""
        }
    }
}

struct PassCodeButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.black)
            VStack {
                HStack {
                    PassCodeButton(number: 1)
                    PassCodeButton(number: 2)
                    PassCodeButton(number: 3)
                }
                HStack {
                    PassCodeButton(number: 4)
                    PassCodeButton(number: 5)
                    PassCodeButton(number: 6)
                }
                HStack {
                    PassCodeButton(number: 7)
                    PassCodeButton(number: 8)
                    PassCodeButton(number: 9)
                }
                PassCodeButton(number: 0)
            }
        }
    }
}
