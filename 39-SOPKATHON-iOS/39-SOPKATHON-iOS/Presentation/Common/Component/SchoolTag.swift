//
//  SchoolTag.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 학교·반 이름 태그. 홈 상단은 `.gray`, 색 배경 위는 `.onDark`.
/// 경기 결과 배너는 `.onLight`·`.dimmed`, 게임방 VS 배너는 준비 상태에 따라 `.matchOnLight`·`.matchDimmed` 사용함.
struct SchoolTag: View {

    enum Style {
        /// 홈 상단 회색 태그
        case gray
        /// 색 배경 위: 흰 글자
        case onDark
        /// 경기 결과 배너에서 이긴 쪽의 상대 학교
        case onLight
        /// 경기 결과 배너에서 패배한 우리 학교
        case dimmed
        /// 게임방 배너의 회색 배경 위(미준비 팀, 다른 팀 준비 후)
        case matchOnLight
        /// 게임방 배너 전체가 회색인 준비 전 상태
        case matchDimmed
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
        case .dimmed: Color(hex: 0x525252)
        case .matchOnLight, .matchDimmed: Color(hex: 0x777777)
        }
    }

    var backgroundColor: Color {
        switch style {
        case .gray: Color(hex: 0xEDEDED)
        case .onDark, .onLight, .matchOnLight: .white.opacity(0.45)
        case .dimmed: Color(hex: 0xA1A1A1, opacity: 0.45)
        case .matchDimmed: Color(hex: 0xABABAB, opacity: 0.45)
        }
    }

}
