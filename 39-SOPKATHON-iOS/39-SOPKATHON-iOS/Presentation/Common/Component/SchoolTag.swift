//
//  SchoolTag.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 학교·반 이름 태그. 홈 상단은 `.gray`, VS 배너 안은 `.onDark`(우리 학교)·`.onLight`(상대 학교).
struct SchoolTag: View {

    enum Style {
        case gray
        case onDark
        case onLight
    }

    let title: String
    var style: Style = .gray

    var body: some View {
        Text(title)
            .appFont(style == .gray ? .bodyMRegular : .captionLMedium)
            .foregroundStyle(textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, style == .gray ? 4 : 2)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

}

private extension SchoolTag {

    var textColor: Color {
        switch style {
        case .gray: Color(hex: 0x6B7280)
        case .onDark: .white
        case .onLight: Color(hex: 0x898989)
        }
    }

    var backgroundColor: Color {
        switch style {
        case .gray: Color(hex: 0xEDEDED)
        case .onDark, .onLight: .white.opacity(0.45)
        }
    }

}
