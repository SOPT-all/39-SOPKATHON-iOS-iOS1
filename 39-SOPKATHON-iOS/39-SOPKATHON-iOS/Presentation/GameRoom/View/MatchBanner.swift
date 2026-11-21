//
//  MatchBanner.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 우리 팀과 상대 팀을 사선으로 나눠 보여주는 VS 배너.
/// 준비 전에는 회색, 우리 팀이 준비하면 왼쪽이 빨간색, 상대 팀이 준비하면 오른쪽이 파란색이 됨.
/// Figma 홈-4(준비 전)·홈-3(우리 팀 준비)·홈-5(양 팀 준비) 335x96 좌표 기준.
struct MatchBanner: View {

    let mySchool: String
    let opponentSchool: String
    let myMembers: [String]
    let opponentMembers: [String]
    let isMyTeamReady: Bool
    let isOpponentReady: Bool

    var body: some View {
        // 종목 카드처럼 좌우 여백을 뺀 폭을 채우도록 Figma 배너를 비율 그대로 확대·축소함.
        Color.clear
            .aspectRatio(Layout.size.width / Layout.size.height, contentMode: .fit)
            .overlay(alignment: .topLeading) {
                GeometryReader { proxy in
                    banner
                        .scaleEffect(proxy.size.width / Layout.size.width, anchor: .topLeading)
                }
            }
    }

}

private extension MatchBanner {

    enum Layout {
        static let size = CGSize(width: 335, height: 96)
    }

    var banner: some View {
        ZStack(alignment: .topLeading) {
            (isMyTeamReady ? Color.mainRed : Palette.idle)

            Image(.imgVsShapeBack)
                .offset(x: 142)
            Image(isOpponentReady ? .imgVsShapeBlue : .imgVsShapeGray)
                .offset(x: 153, y: -4)

            SchoolTag(title: mySchool, style: isMyTeamReady ? .onDark : .matchDimmed)
                .offset(x: 8, y: 7)
            SchoolTag(title: opponentSchool, style: opponentTagStyle)
                .offset(x: isAnyReady ? 191 : 192, y: isAnyReady ? 66 : 7)

            avatarPair(myMembers, color: isMyTeamReady ? .mainRed : .black)
                .offset(x: 12, y: 39)
            avatarPair(opponentMembers, color: isOpponentReady ? Palette.blue : .black)
                .offset(x: isAnyReady ? 248 : 245, y: isAnyReady ? 14 : 39)

            if isMyTeamReady {
                readyLettering
                    .offset(x: 89, y: 67)
            }
            if isOpponentReady {
                readyLettering
                    .offset(x: 183, y: 9)
            }
        }
        .frame(width: Layout.size.width, height: Layout.size.height)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .animation(.easeInOut(duration: 0.25), value: isMyTeamReady)
        .animation(.easeInOut(duration: 0.25), value: isOpponentReady)
    }

    enum Palette {
        static let idle = Color(hex: 0xD8D8D8)
        static let blue = Color(hex: 0x1A4196)
    }

    /// Figma에서 어느 팀이든 준비하면 상대 팀 프로필이 위로, 학교 태그가 아래로 이동함.
    var isAnyReady: Bool {
        isMyTeamReady || isOpponentReady
    }

    var opponentTagStyle: SchoolTag.Style {
        if isOpponentReady { return .onDark }
        return isAnyReady ? .matchOnLight : .matchDimmed
    }

    var readyLettering: some View {
        Image(.imgReady)
            .renderingMode(.template)
            .foregroundStyle(.white)
            .transition(.scale(scale: 0.6).combined(with: .opacity))
    }

    /// 왼쪽 프로필이 위에 오도록 두 명을 34pt 간격으로 겹쳐 배치함.
    func avatarPair(_ names: [String], color: Color) -> some View {
        ZStack(alignment: .leading) {
            ForEach(Array(names.prefix(2).enumerated()).reversed(), id: \.offset) { index, name in
                ProfileAvatar(name: name, size: 43, style: .light, letteringColor: color)
                    .offset(x: CGFloat(index) * 34)
            }
        }
    }

}
