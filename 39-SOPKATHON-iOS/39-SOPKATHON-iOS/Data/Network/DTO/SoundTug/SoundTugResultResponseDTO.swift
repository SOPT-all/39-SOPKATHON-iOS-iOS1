//
//  SoundTugResultResponseDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

struct SoundTugResultResponseDTO: Decodable {

    struct Team: Decodable {
        let teamSlot: Int
        let totalMaxDecibel: Double?
        let result: String?
    }

    let matchID: Int
    let gameType: String
    let status: String
    let winnerTeamSlot: Int?
    let teams: [Team]

    enum CodingKeys: String, CodingKey {
        case matchID = "matchId"
        case gameType
        case status
        case winnerTeamSlot
        case teams
    }

    func toResult(context: SoundTugMatchContext) throws -> SoundTugResult {
        guard matchID == context.matchID, gameType == "VOICE_TUG" else {
            throw SoundTugAPIError.invalidResult
        }
        if status == "INVALID" {
            return SoundTugResult(
                mySchool: "우리 팀", opponentSchool: "상대 팀",
                myTeamTotalDecibel: nil, opponentTeamTotalDecibel: nil, outcome: .invalid
            )
        }
        if status == "IN_PROGRESS" { throw SoundTugAPIError.resultPending }
        guard status == "FINISHED", teams.count == 2,
              let mine = teams.first(where: { $0.teamSlot == context.myTeamSlot }),
              let opponent = teams.first(where: { $0.teamSlot != context.myTeamSlot }),
              let myTotal = mine.totalMaxDecibel, myTotal.isFinite, myTotal >= 0,
              let opponentTotal = opponent.totalMaxDecibel,
              opponentTotal.isFinite, opponentTotal >= 0 else {
            throw SoundTugAPIError.invalidResult
        }
        let outcome: SoundTugResult.Outcome
        switch (mine.result, opponent.result, winnerTeamSlot) {
        case ("WIN", "LOSE", context.myTeamSlot):
            outcome = .win
        case ("LOSE", "WIN", opponent.teamSlot):
            outcome = .lose
        case ("DRAW", "DRAW", nil):
            outcome = .draw
        default:
            throw SoundTugAPIError.invalidResult
        }
        return SoundTugResult(
            mySchool: "우리 팀", opponentSchool: "상대 팀",
            myTeamTotalDecibel: myTotal, opponentTeamTotalDecibel: opponentTotal,
            outcome: outcome
        )
    }

}
