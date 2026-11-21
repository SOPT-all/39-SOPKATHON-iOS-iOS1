//
//  HomeMember.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import Foundation

/// 홈 멤버 카드에 표시하는 반 멤버.
struct HomeMember: Identifiable {

    let id = UUID()
    let name: String
    let isActive: Bool

}
