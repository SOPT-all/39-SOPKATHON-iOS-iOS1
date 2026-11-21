//
//  AppRoute.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

enum AppRoute: Hashable {

    /// 상대 팀 매칭 대기
    case matching
    case gameRoom
    case game(Game)
    /// 전국·교내 랭킹
    case ranking

}
