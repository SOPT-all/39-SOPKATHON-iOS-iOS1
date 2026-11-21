//
//  SoundTugRecordDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

struct SoundTugRecordRequestDTO: Encodable {

    let maxDecibel: Double

}

struct SoundTugRecordResponseDTO: Decodable {

    let matchID: Int
    let memberID: Int
    let maxDecibel: Double
    let recordStatus: String
    let isResultFinalized: Bool

    enum CodingKeys: String, CodingKey {
        case matchID = "matchId"
        case memberID = "memberId"
        case maxDecibel
        case recordStatus
        case isResultFinalized
    }

    func validate(context: SoundTugMatchContext) throws {
        guard matchID == context.matchID, memberID == context.memberID,
              recordStatus == "SUBMITTED", maxDecibel.isFinite, maxDecibel >= 0 else {
            throw SoundTugAPIError.invalidSubmission
        }
    }

}
