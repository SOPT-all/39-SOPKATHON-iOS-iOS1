//
//  Game.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 게임 종목. 게임 선택 카드와 게임 화면 이동에서 사용함.
enum Game: CaseIterable, Hashable {

    case horseRace
    case tugOfWar

    var title: String {
        switch self {
        case .horseRace: "Tap! 이어달리기"
        case .tugOfWar: "소리 줄다리기"
        }
    }

    // TODO: 소리 줄다리기 설명은 Figma에 경마 문구가 복사돼 있어 와이어프레임 문구를 사용함. 확정 문구 필요.
    var description: String {
        switch self {
        case .horseRace: "손가락을 빠르게 터치해 말을 결승선까지 보내요!"
        case .tugOfWar: "마이크로 소리를 내며 줄을 당깁니다."
        }
    }

}
