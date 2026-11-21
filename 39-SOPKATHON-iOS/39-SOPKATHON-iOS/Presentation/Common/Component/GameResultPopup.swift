//
//  GameResultPopup.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

/// 경기 완료 후 보여주는 승패 배너와 결과 카드. 승패 판정은 호출하는 화면이 정함.
/// 사용 예: GameResultPopup(..., myTeamRecord: .finishTime(milliseconds: 12500), ...)
struct GameResultPopup: View {

    /// 팀 기록. 서버 응답 필드의 값과 단위를 그대로 받음.
    enum Record {
        /// 경마 `totalFinishTimeMilliseconds`. "12.50초"로 표시함.
        case finishTime(milliseconds: Int64)
        /// 시연 보정 음량 합계. 실제 소음계 SPL 측정값이 아님.
        case demoDecibel(Double)
    }

    let gameTitle: String
    let mySchool: String
    let opponentSchool: String
    let isWin: Bool?
    let myTeamRecord: Record?
    let opponentTeamRecord: Record?
    /// 점수가 없으면 nil이며 "-"로 표시함.
    let score: Int?
    let onNextGame: () -> Void
    let onGoHome: () -> Void
    var teamRecordTitle = "평균 기록"
    var personalRecord: Record? = nil
    var personalRecordTitle = "내 기록"
    var resultMessage: String? = nil
    var isLoading = false
    var onRetry: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 13) {
            if let isWin {
                GameResultBanner(mySchool: mySchool, opponentSchool: opponentSchool, isWin: isWin)
            }
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
                if let onRetry {
                    GameResultButton(
                        title: "다시 시도",
                        foreground: .white,
                        background: .mainRed,
                        action: onRetry
                    )
                }
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
            if isLoading {
                ProgressView()
                    .tint(.mainRed)
            }
            if let resultMessage {
                Text(resultMessage)
                    .appFont(.captionLRegular)
                    .multilineTextAlignment(.center)
            }
            if let personalRecord {
                recordRow(title: personalRecordTitle, value: recordText(personalRecord))
            }
            recordRow(title: "우리 팀 \(teamRecordTitle)", value: recordText(myTeamRecord))
            recordRow(title: "상대 팀 \(teamRecordTitle)", value: recordText(opponentTeamRecord))
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

    func recordText(_ record: Record?) -> String {
        guard let record else { return "-" }
        switch record {
        case .finishTime(let milliseconds):
            return String(format: "%.2f초", Double(milliseconds) / 1000)
        case .demoDecibel(let decibel):
            return String(format: "%.1fdB(시연)", decibel)
        }
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
