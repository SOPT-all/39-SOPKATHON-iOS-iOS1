//
//  SoundTugGameOver.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import SwiftUI

struct SoundTugGameOver: View {

    let personalDecibel: Double
    let result: SoundTugResult?
    let onNextGame: () -> Void
    let onGoHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)

            // TODO: 서버 결과 연동이 안정되면 고정값 대신 result 값 사용 필요. 지금은 시연용으로 승리·팀 음량·점수를 고정함.
            GameResultPopup(
                gameTitle: Game.tugOfWar.title,
                mySchool: result?.mySchool ?? "우리 팀",
                opponentSchool: result?.opponentSchool ?? "상대 팀",
                isWin: true,
                myTeamRecord: .demoDecibel(DemoResult.myTeamDecibel),
                opponentTeamRecord: .demoDecibel(DemoResult.opponentTeamDecibel),
                score: DemoResult.score,
                onNextGame: onNextGame,
                onGoHome: onGoHome,
                teamRecordTitle: "총 음량",
                personalRecord: .demoDecibel(personalDecibel),
                personalRecordTitle: "내 최고 음량"
            )
            .offset(y: -33)
        }
        .ignoresSafeArea()
    }

}

private extension SoundTugGameOver {

    enum DemoResult {
        static let myTeamDecibel = 94.7
        static let opponentTeamDecibel = 85.4
        static let score = 300
    }

}
