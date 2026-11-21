//
//  SchoolTag.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 학교·반 이름 태그. 홈 상단은 `.gray`, VS 배너 안은 준비 상태에 따라 `.onDark`·`.onLight`·`.dimmed`.
struct SchoolTag: View {

    enum Style {
        /// 홈 상단 회색 태그
        case gray
        /// 배너의 색 배경 위(준비 완료 팀): 흰 글자
        case onDark
        /// 배너의 회색 배경 위(미준비 팀, 다른 팀 준비 후): 회색 글자
        case onLight
        /// 배너 전체가 회색인 준비 전 상태
        case dimmed
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
        case .onLight, .dimmed: Color(hex: 0x777777)
        }
    }

    var backgroundColor: Color {
        switch style {
        case .gray: Color(hex: 0xEDEDED)
        case .onDark, .onLight: .white.opacity(0.45)
        case .dimmed: Color(hex: 0xABABAB, opacity: 0.45)
        }
    }

}
