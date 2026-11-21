//
//  HorseRecordDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

struct HorseRecordSubmitRequestDTO: Encodable {

    let elapsedMilliseconds: Int64

}

struct HorseRecordSubmitResponseDTO: Decodable {

    let finishTimeMilliseconds: Int64

}
