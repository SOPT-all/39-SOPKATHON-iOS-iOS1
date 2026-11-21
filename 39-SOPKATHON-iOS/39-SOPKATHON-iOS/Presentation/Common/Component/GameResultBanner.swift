//
//  GameResultBanner.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

/// 경기 결과 팝업 위의 승패 배너. Figma 335 x 96 프레임 좌표에 맞춰 배치함.
/// 왼쪽이 우리 학교, 오른쪽이 상대 학교이며 이긴 쪽만 색을 칠함.
struct GameResultBanner: View {

    let mySchool: String
    let opponentSchool: String
    let isWin: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            isWin ? Color.mainRed : Palette.dimmedBackground

            Image(.imgVsShapeBack)
                .offset(x: 142)

            Image(.imgResultMyEmblem)
                .resizable()
                .scaledToFill()
                .frame(width: 112, height: 96)
                .clipped()
                .opacity(isWin ? 1 : 0.2)
                .offset(x: -24, y: 36)

            Image(.imgVsShapeFront)
                .renderingMode(.template)
                .foregroundStyle(isWin ? Palette.dimmedOpponent : Palette.opponent)
                .offset(x: 153, y: -4)

            // 승리 시에는 덮개가 상대 학교 태그까지 어둡게 덮고, 패배 시에는 태그가 파란 덮개 위에 보임.
            if isWin {
                schoolTags
                opponentCover
            } else {
                opponentCover
                schoolTags
            }

            Image(.imgResultWinText)
                .renderingMode(.template)
                .foregroundStyle(isWin ? .white : Palette.dimmedText)
                .offset(x: 84, y: 46)

            Image(.imgResultLoseText)
                .renderingMode(.template)
                .foregroundStyle(isWin ? Palette.dimmedText : .white)
                .offset(x: 195, y: 46)

            Image(isWin ? .imgResultOpponentLogoDimmed : .imgResultOpponentLogo)
                .offset(x: 265, y: 29)
        }
        // 도형·로고가 프레임 밖으로 커서 가운데 정렬하면 위로 밀리므로 왼쪽 위에 맞춤.
        .frame(width: 335, height: 96, alignment: .topLeading)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(mySchool) \(isWin ? "승리" : "패배"), \(opponentSchool) \(isWin ? "패배" : "승리")"
        )
    }

}

private extension GameResultBanner {

    var schoolTags: some View {
        ZStack(alignment: .topLeading) {
            SchoolTag(title: mySchool, style: isWin ? .onDark : .dimmed)
                .offset(x: 8, y: 7)
            SchoolTag(title: opponentSchool, style: isWin ? .onLight : .onDark)
                .offset(x: 192, y: 7)
        }
    }

    var opponentCover: some View {
        Image(.imgResultCoverShape)
            .renderingMode(.template)
            .foregroundStyle(isWin ? Palette.opponentCoverDimmed : Palette.opponent)
            .offset(x: 155)
    }

    /// Figma 배너 색상. 디자인시스템 토큰에 없는 값임.
    enum Palette {
        static let dimmedBackground = Color(hex: 0x898989)
        static let dimmedOpponent = Color(hex: 0xE4E4E4)
        static let opponentCoverDimmed = Color.black.opacity(0.4)
        static let opponent = Color(hex: 0x1A4196)
        static let dimmedText = Color(hex: 0x545454)
    }

}
