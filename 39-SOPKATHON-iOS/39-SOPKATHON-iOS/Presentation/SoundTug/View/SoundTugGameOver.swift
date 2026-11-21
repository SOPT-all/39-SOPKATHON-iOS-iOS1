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
    let isLoading: Bool
    let statusMessage: String?
    let onRetry: (() -> Void)?

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)

            GameResultPopup(
                gameTitle: Game.tugOfWar.title,
                mySchool: result?.mySchool ?? "우리 팀",
                opponentSchool: result?.opponentSchool ?? "상대 팀",
                isWin: isWin,
                myTeamRecord: result?.myTeamTotalDecibel.map { .demoDecibel($0) },
                opponentTeamRecord: result?.opponentTeamTotalDecibel.map { .demoDecibel($0) },
                score: result?.reward,
                onNextGame: onNextGame,
                onGoHome: onGoHome,
                teamRecordTitle: "총 음량",
                personalRecord: .demoDecibel(personalDecibel),
                personalRecordTitle: "내 최고 음량",
                resultMessage: resultMessage,
                isLoading: isLoading,
                onRetry: onRetry
            )
            .offset(y: -33)
        }
        .ignoresSafeArea()
    }

    private var isWin: Bool? {
        switch result?.outcome {
        case .win: true
        case .lose: false
        case .draw, .invalid, nil: nil
        }
    }

    private var resultMessage: String? {
        switch result?.outcome {
        case .win, .lose: nil
        case .draw: "무승부"
        case .invalid: "무효 경기"
        case nil: statusMessage
        }
    }

}
