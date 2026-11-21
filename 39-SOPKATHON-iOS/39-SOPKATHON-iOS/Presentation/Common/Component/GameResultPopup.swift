//
//  GameResultPopup.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

/// 경기 완료 후 보여주는 승패 배너와 결과 카드. 승패 판정은 호출하는 화면이 정함.
/// 사용 예: GameResultPopup(gameTitle: Game.horseRace.title, mySchool: "솝트고등학교 1학년 1반", ...)
struct GameResultPopup: View {

    let gameTitle: String
    let mySchool: String
    let opponentSchool: String
    let isWin: Bool
    let myTeamAverageRecord: TimeInterval
    let opponentTeamAverageRecord: TimeInterval
    /// 점수가 없으면 nil이며 "-"로 표시함.
    let score: Int?
    let onNextGame: () -> Void
    let onGoHome: () -> Void

    var body: some View {
        VStack(spacing: 13) {
            GameResultBanner(mySchool: mySchool, opponentSchool: opponentSchool, isWin: isWin)
            resultCard
        }
    }

}

private extension GameResultPopup {

    var resultCard: some View {
        VStack(spacing: 0) {
            Image(.imgResultTitle)
                // 기울인 글자라 Figma에서 카드 중앙보다 4pt 오른쪽에 둠.
                .offset(x: 4)
                .padding(.top, 25)
                .accessibilityLabel("경기 종료!")

            Rectangle()
                .fill(.grey1)
                .frame(width: 286, height: 1)
                .padding(.top, 12)

            records
                .frame(width: 282)
                .padding(.top, 14)

            VStack(spacing: 6) {
                GameResultButton(
                    title: "다음 게임 이어가기",
                    foreground: .white,
                    background: .mainRed,
                    action: onNextGame
                )
                GameResultButton(
                    title: "홈 화면으로 이동",
                    foreground: Palette.homeButtonText,
                    background: Palette.homeButtonBackground,
                    action: onGoHome
                )
            }
            .padding(.horizontal, 12)
            .padding(.top, 14)
        }
        .padding(.bottom, 14)
        .frame(width: 335)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    var records: some View {
        VStack(spacing: 8) {
            recordRow(title: "게임", value: gameTitle, isEmphasized: true)
            recordRow(title: "우리 팀 평균 기록", value: recordText(myTeamAverageRecord))
            recordRow(title: "상대 팀 평균 기록", value: recordText(opponentTeamAverageRecord))
            recordRow(title: "획득 점수", value: score.map { "\($0)점" } ?? "-")
        }
        .foregroundStyle(Palette.recordText)
    }

    func recordRow(title: String, value: String, isEmphasized: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(AppFont.captionLRegular.font)
            Spacer()
            Text(value)
                .font(isEmphasized ? .pretendard(.bold, size: 12) : AppFont.captionLRegular.font)
        }
        // Figma 행간 18pt. 한 줄 텍스트라 appFont 대신 높이로 맞춤.
        .frame(height: 18)
    }

    func recordText(_ record: TimeInterval) -> String {
        String(format: "%.2f초", record)
    }

    /// Figma 결과 카드 색상. 디자인시스템 토큰에 없는 값임.
    enum Palette {
        static let recordText = Color(hex: 0x374151)
        static let homeButtonText = Color(hex: 0x888888)
        static let homeButtonBackground = Color(hex: 0xD9D9D9)
    }

}

private struct GameResultButton: View {

    let title: String
    let foreground: Color
    let background: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .appFont(.subHeaderSSemiBold)
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .buttonStyle(.plain)
    }

}
