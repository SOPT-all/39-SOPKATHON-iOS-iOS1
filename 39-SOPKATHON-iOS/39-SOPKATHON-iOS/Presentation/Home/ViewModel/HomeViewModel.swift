//
//  HomeViewModel.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import Foundation

@Observable
final class HomeViewModel {

    // TODO: 온보딩 정보 연동 전까지 목데이터 사용.
    let myName = "민서"
    let schoolName = "솝트고등학교"

    // 명세상 활동 상태는 UI 전용이라 서버 없이 목데이터로 표시함. 이름·순서는 Figma 기준.
    let members: [HomeMember] = [
        HomeMember(name: "김민서", isActive: true),
        HomeMember(name: "김지우", isActive: true),
        HomeMember(name: "김대운", isActive: false),
        HomeMember(name: "하륜영", isActive: false)
    ]

}
