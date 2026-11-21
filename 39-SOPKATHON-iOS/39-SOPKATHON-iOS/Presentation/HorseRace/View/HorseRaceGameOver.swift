//
//  HorseRaceGameOver.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

/// 완주 후 화면 전체를 어둡게 덮음. 결과가 없으면 "경기 종료!"를, 결과가 오면 결과 팝업을 보여줌.
struct HorseRaceGameOver: View {

    let result: HorseRaceResult?
    let onNextGame: () -> Void
    let onGoHome: () -> Void

    var body: some View {
        // 덮개가 아래 연타 버튼의 탭도 막음.
        ZStack {
            Color.black.opacity(0.7)

            if let result {
                GameResultPopup(
                    gameTitle: Game.horseRace.title,
                    mySchool: result.mySchool,
                    opponentSchool: result.opponentSchool,
                    isWin: result.isWin,
                    myTeamRecord: .finishTime(milliseconds: result.myTeamFinishTimeMilliseconds),
                    opponentTeamRecord: .finishTime(
                        milliseconds: result.opponentTeamFinishTimeMilliseconds
                    ),
                    // TODO: 서버 승점 연동이 안정되면 result.score로 되돌림. 지금은 시연용으로 300점 고정함.
                    score: 300,
                    onNextGame: onNextGame,
                    onGoHome: onGoHome,
                    resultMessage: result.isWin == nil ? "무승부" : nil
                )
                // Figma 375 x 812 프레임에서 팝업 묶음이 화면 중앙보다 33pt 위에 있음.
                .offset(y: -33)
            } else {
                Image(.horseRaceFinishTitle)
                    // Figma 375 x 812 프레임에서 글자가 화면 중앙보다 23.5pt 위에 있음.
                    .offset(y: -23.5)
                    .accessibilityLabel("경기 종료!")
            }
        }
        .ignoresSafeArea()
    }

}
