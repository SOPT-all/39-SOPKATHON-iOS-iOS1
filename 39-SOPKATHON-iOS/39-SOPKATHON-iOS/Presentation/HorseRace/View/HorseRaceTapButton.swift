//
//  HorseRaceTapButton.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

struct HorseRaceTapButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .appFont(.subHeaderSSemiBold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(.black, in: .rect(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

}
