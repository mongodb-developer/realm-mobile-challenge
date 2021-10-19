//
//  DigitProgressView.swift
//  RChat
//
//  Created by Andrew Morgan on 20/09/2021.
//

import SwiftUI

struct DigitProgressView: View {
    let pin: String
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach((1...6), id: \.self) { index in
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                    if pin.count >= index {
                        Circle()
                            .fill(.white)
                    }
                }
            }
        }
    }
}

struct DigitProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DigitProgressView(pin: "1234")
            .frame(maxHeight: 20)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.black)
    }
}
