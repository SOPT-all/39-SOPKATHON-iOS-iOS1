//
//  GameRoomViewModel.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import Foundation

@Observable
final class GameRoomViewModel {

    enum Phase: Equatable {
        /// 양 팀 준비 대기
        case waiting
        /// 전원 준비 완료, 종목 선택 가능
        case selecting
        /// 종목 확정 후 당선 배지 표시
        case selected(Game)
        /// 3·2·1 카운트다운(Lottie 재생 중)
        case countdown(Game)
        /// 카운트다운 종료, 게임 시작
        case started(Game)
    }

    // TODO: 매칭 API 연동 전까지 목데이터 사용. 이름은 서버 고정값(민서·지우 / 륜영·수현).
    let mySchool = "솝트고등학교 3학년 2반"
    let opponentSchool = "부디고등학교 3학년 2반"
    let myMembers = ["민서", "지우"]
    let opponentMembers = ["륜영", "수현"]

    private(set) var isMyTeamReady = false
    private(set) var isOpponentReady = false
    private(set) var phase: Phase = .waiting

    private var flowTask: Task<Void, Never>?

    /// Lottie 재생 시간(3초)보다 조금 길게 둔 대비 시간.
    private static let countdownTimeout: Double = 3.5

    var isAllReady: Bool {
        isMyTeamReady && isOpponentReady
    }

    var selectedGame: Game? {
        switch phase {
        case .selected(let game), .countdown(let game), .started(let game): game
        case .waiting, .selecting: nil
        }
    }

    var isCountingDown: Bool {
        guard case .countdown = phase else { return false }
        return true
    }

    var startedGame: Game? {
        guard case .started(let game) = phase else { return nil }
        return game
    }

    func ready() {
        guard phase == .waiting, !isMyTeamReady else { return }
        isMyTeamReady = true
        // TODO: 폴링 연동 후 서버의 상대 팀 준비 상태로 교체. 지금은 잠시 뒤 상대 팀이 준비한 것으로 처리함.
        runFlow { viewModel in
            if !viewModel.isOpponentReady {
                try await Task.sleep(for: .seconds(1.5))
                viewModel.isOpponentReady = true
            }
            // Figma S02-C(양 팀 준비 배너)를 잠깐 보여준 뒤 종목 선택으로 넘어감.
            try await Task.sleep(for: .seconds(1.5))
            viewModel.phase = .selecting
        }
    }

    func cancelReady() {
        guard phase == .waiting, isMyTeamReady else { return }
        flowTask?.cancel()
        isMyTeamReady = false
    }

    /// 먼저 선택한 종목으로 확정하고 당선 배지를 보여준 뒤 3·2·1 카운트다운을 진행함.
    func select(_ game: Game) {
        guard phase == .selecting else { return }
        // TODO: 서버 선착순 확정 결과로 교체.
        phase = .selected(game)
        runFlow { viewModel in
            try await Task.sleep(for: .seconds(1))
            viewModel.phase = .countdown(game)
            // Lottie 완료 알림이 오지 않는 경우(리소스 로드 실패 등)에도 게임이 시작되도록 대비함.
            try await Task.sleep(for: .seconds(Self.countdownTimeout))
            viewModel.finishCountdown()
        }
    }

    /// 3·2·1 Lottie 재생이 끝나면 게임을 시작함. 여러 번 불려도 한 번만 시작함.
    func finishCountdown() {
        guard case .countdown(let game) = phase else { return }
        phase = .started(game)
    }

    /// 화면을 벗어나면 진행 중인 대기·카운트다운을 멈춤.
    func stop() {
        flowTask?.cancel()
    }

}

private extension GameRoomViewModel {

    func runFlow(_ operation: @escaping (GameRoomViewModel) async throws -> Void) {
        flowTask?.cancel()
        flowTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await operation(self)
            } catch {
                // 화면 이탈·준비 취소로 취소된 경우라 상태를 바꾸지 않고 끝냄.
            }
        }
    }

}
