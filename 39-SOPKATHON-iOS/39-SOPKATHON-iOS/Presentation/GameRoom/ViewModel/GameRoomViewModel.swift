//
//  GameRoomViewModel.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import Foundation

@Observable
final class GameRoomViewModel {

    // TODO: 매칭 API 연동 전까지 목데이터 사용.
    let mySchool = "솝트고등학교 3학년 2반"
    let opponentSchool = "부디고등학교 3학년 2반"
    let myMembers: [String?] = ["륜영", "수현"]
    let opponentCount = 2

    private(set) var isMeReady = false
    private(set) var selectedGame: Game?

    // TODO: 폴링 연동 후 서버의 팀원 준비 상태로 교체. 지금은 다른 팀원은 모두 준비된 것으로 둠.
    private let isOthersReady = true

    /// 전원이 준비 완료해야 종목을 선택할 수 있음.
    var isAllReady: Bool {
        isMeReady && isOthersReady
    }

    func ready() {
        isMeReady = true
    }

    func select(_ game: Game) -> Bool {
        guard isAllReady else { return false }
        selectedGame = game
        return true
    }

}
