//
//  ProfileAvatar.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 원형 프로필. 이름이 있으면 이름을, 없으면 캐릭터 실루엣을 표시함.
/// 사용 예: ProfileAvatar(name: "륜영", size: 48), ProfileAvatar(name: nil, size: 72, style: .inactive)
/// Figma 손글씨 이미지가 있는 이름은 이미지로, 없는 이름은 텍스트로 표시함.
struct ProfileAvatar: View {

    enum Style {
        /// 홈 상단 내 프로필: 검정 배경, 흰 글자
        case dark
        /// VS 배너: 흰 배경, 검정 글자·캐릭터, 흰 테두리
        case light
        /// 활성 멤버 카드: 흰 배경, 빨간 글자
        case highlight
        /// 오프라인 멤버 카드: 흰 배경, 회색 캐릭터
        case inactive
    }

    let name: String?
    let size: CGFloat
    var style: Style = .dark
    /// 이름·캐릭터 색을 스타일 기본값 대신 지정할 때 사용함. 예: VS 배너의 준비 완료 팀 색.
    var letteringColor: Color?

    var body: some View {
        content
            .frame(width: size, height: size)
            .background {
                Circle()
                    .fill(backgroundColor)
                    .shadow(color: shadowColor, radius: 2, x: 3)
            }
            .overlay {
                if style == .light {
                    Circle().stroke(.white, lineWidth: 2)
                }
            }
    }

}

private extension ProfileAvatar {

    /// Figma에 손글씨 이미지로 그려진 이름.
    static let nameLetterings: [String: ImageResource] = [
        "민서": .imgNameMinseo,
        "지우": .imgNameJiu,
        "륜영": .imgNameRyunyeong,
        "수현": .imgNameSuhyeon
    ]

    @ViewBuilder
    var content: some View {
        if let name, let lettering = Self.nameLetterings[name] {
            Image(lettering)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(foregroundColor)
                .frame(width: size * 0.65)
        } else if let name {
            Text(name)
                .font(.pretendard(.extraBold, size: size * 0.34))
                .foregroundStyle(foregroundColor)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .padding(size * 0.1)
        } else {
            Image(.imgCharacter)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(foregroundColor)
                .frame(height: size * 0.62)
        }
    }

    var foregroundColor: Color {
        if let letteringColor { return letteringColor }
        return switch style {
        case .dark: .white
        case .light: .black
        case .highlight: .mainRed
        case .inactive: Color(hex: 0xD7D7D7)
        }
    }

    var backgroundColor: Color {
        switch style {
        case .dark: .black
        case .light, .highlight, .inactive: .white
        }
    }

    /// Figma VS 배너의 이름 프로필에만 그림자가 있음.
    var shadowColor: Color {
        style == .light && name != nil ? .black.opacity(0.25) : .clear
    }

}
