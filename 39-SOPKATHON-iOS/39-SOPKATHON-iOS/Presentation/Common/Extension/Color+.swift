//
//  Color+.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

extension Color {

    /// 사용 예: Color(hex: 0xBD2E20)
    init(
        hex: UInt,
        opacity: Double = 1
    ) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

}
