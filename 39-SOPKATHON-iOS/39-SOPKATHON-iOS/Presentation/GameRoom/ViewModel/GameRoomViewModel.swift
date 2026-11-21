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
    /// 알림으로 보여줄 오류 문구. 알림을 닫으면 nil로 되돌림.
    private(set) var errorMessage: String?

    private let match: GameRoomMatch?
    private let service: BaseService
    private var flowTask: Task<Void, Never>?
    private var pollingTask: Task<Void, Never>?
    private var isRequestingReady = false
    private var isRequestingGameType = false

    /// Lottie 재생 시간(3초)보다 조금 길게 둔 대비 시간.
    private static let countdownTimeout: Double = 3.5
    // 상대 준비·종목 확정을 빨리 반영하려고 서버 명세의 조회 간격(3초)보다 짧게 둠.
    private static let pollingInterval: Duration = .seconds(1)

    init(match: GameRoomMatch? = .demo, service: BaseService = .shared) {
        self.match = match
        self.service = service
    }

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

    /// 준비 상태와 확정 종목을 일정 간격으로 조회함. 화면에 들어올 때 호출함.
    func start() {
        guard let match else {
            errorMessage = "경기 정보를 불러올 수 없어요."
            return
        }
        pollingTask?.cancel()
        pollingTask = Task { [weak self] in
            await self?.poll(match: match)
        }
    }

    func ready() {
        guard phase == .waiting, !isMyTeamReady, !isRequestingReady, let match else { return }
        isMyTeamReady = true
        isRequestingReady = true
        Task {
            defer { isRequestingReady = false }
            do {
                let response: MatchReadyResponseDTO = try await service.request(
                    endPoint: .updateReady(matchID: match.matchID, memberID: match.memberID),
                    body: MatchReadyRequestDTO(isReady: true)
                )
                isMyTeamReady = response.isMineReady
            } catch {
                isMyTeamReady = false
                errorMessage = "준비 완료를 보내지 못했어요. 다시 시도해 주세요."
            }
        }
    }

    /// 선착순 확정을 요청함. 상대가 먼저 확정했으면 서버가 돌려준 상대 종목으로 진행함.
    func select(_ game: Game) {
        guard phase == .selecting, !isRequestingGameType, let match else { return }
        isRequestingGameType = true
        Task {
            defer { isRequestingGameType = false }
            do {
                let response: MatchGameTypeResponseDTO = try await service.request(
                    endPoint: .updateGameType(matchID: match.matchID, memberID: match.memberID),
                    body: MatchGameTypeRequestDTO(gameType: game.gameType)
                )
                if let gameType = response.gameType {
                    confirm(Game(gameType: gameType))
                }
            } catch {
                errorMessage = "종목을 확정하지 못했어요. 다시 시도해 주세요."
            }
        }
    }

    /// 3·2·1 Lottie 재생이 끝나면 게임을 시작함. 여러 번 불려도 한 번만 시작함.
    func finishCountdown() {
        guard case .countdown(let game) = phase else { return }
        phase = .started(game)
    }

    /// 게임을 마치고 게임방으로 돌아오면 다음 판을 위해 준비 전 상태로 되돌림.
    func resetAfterGame() {
        guard case .started = phase else { return }
        flowTask?.cancel()
        isMyTeamReady = false
        isOpponentReady = false
        phase = .waiting
    }

    func dismissError() {
        errorMessage = nil
    }

    /// 화면을 벗어나면 진행 중인 조회·대기·카운트다운을 멈춤.
    func stop() {
        pollingTask?.cancel()
        flowTask?.cancel()
    }

}

private extension GameRoomViewModel {

    /// 준비 대기 중에는 준비 상태, 종목 선택 중에는 확정 종목을 조회함. 종목이 확정되면 멈춤.
    func poll(match: GameRoomMatch) async {
        while !Task.isCancelled {
            do {
                let shouldContinue: Bool
                switch phase {
                case .waiting:
                    shouldContinue = try await checkReady(match: match)
                case .selecting:
                    shouldContinue = try await checkGameType(match: match)
                case .selected, .countdown, .started:
                    shouldContinue = false
                }
                guard shouldContinue else { return }
            } catch is CancellationError {
                return
            } catch {
                // 조회 실패는 일시적일 수 있어 다음 간격에 다시 조회함.
            }

            do {
                try await Task.sleep(for: Self.pollingInterval)
            } catch {
                // 화면 이탈로 task가 취소된 경우라 조회를 멈춤.
                return
            }
        }
    }

    /// 경기가 비정상 종료됐으면 false를 반환해 조회를 멈춤.
    func checkReady(match: GameRoomMatch) async throws -> Bool {
        let response: MatchReadyResponseDTO = try await service.request(
            endPoint: .readyStatus(matchID: match.matchID, memberID: match.memberID)
        )
        guard phase == .waiting else { return true }
        // 준비 요청 중에는 응답 전 조회 결과로 버튼이 되돌아가지 않게 함.
        if !isRequestingReady {
            isMyTeamReady = response.isMineReady
        }
        // 팀당 1명(참가자 2명) 기준. 내 준비를 뺀 준비 수가 있으면 상대 팀이 준비한 것으로 봄.
        isOpponentReady = response.readyCount - (response.isMineReady ? 1 : 0) > 0

        switch response.status {
        case .searching:
            return true
        case .found, .inProgress, .finished:
            // Figma S02-C(양 팀 준비 배너)를 잠깐 보여준 뒤 종목 선택으로 넘어감.
            try await Task.sleep(for: .seconds(1.5))
            if phase == .waiting {
                phase = .selecting
            }
            return true
        case .timeout, .cancelled, .invalid:
            errorMessage = "경기가 종료되어 진행할 수 없어요."
            return false
        }
    }

    /// 경기가 비정상 종료됐으면 false를 반환해 조회를 멈춤.
    func checkGameType(match: GameRoomMatch) async throws -> Bool {
        let response: MatchGameTypeResponseDTO = try await service.request(
            endPoint: .gameType(matchID: match.matchID)
        )
        switch response.status {
        case .inProgress:
            if let gameType = response.gameType {
                confirm(Game(gameType: gameType))
            }
            return true
        case .searching, .found, .finished:
            return true
        case .timeout, .cancelled, .invalid:
            errorMessage = "경기가 종료되어 진행할 수 없어요."
            return false
        }
    }

    /// 서버가 확정한 종목으로 당선 배지를 보여준 뒤 3·2·1 카운트다운을 진행함. 여러 번 불려도 한 번만 진행함.
    func confirm(_ game: Game) {
        guard phase == .selecting else { return }
        phase = .selected(game)
        runFlow { viewModel in
            try await Task.sleep(for: .seconds(1))
            viewModel.phase = .countdown(game)
            // Lottie 완료 알림이 오지 않는 경우(리소스 로드 실패 등)에도 게임이 시작되도록 대비함.
            try await Task.sleep(for: .seconds(Self.countdownTimeout))
            viewModel.finishCountdown()
        }
    }

    func runFlow(_ operation: @escaping (GameRoomViewModel) async throws -> Void) {
        flowTask?.cancel()
        flowTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await operation(self)
            } catch {
                // 화면 이탈로 취소된 경우라 상태를 바꾸지 않고 끝냄.
            }
        }
    }

}
