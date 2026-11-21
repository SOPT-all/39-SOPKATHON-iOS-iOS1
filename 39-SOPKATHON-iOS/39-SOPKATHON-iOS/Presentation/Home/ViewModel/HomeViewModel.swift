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
    let myName = "륜영"
    let schoolName = "솝트고등학교"

    // 명세상 활동 상태는 UI 전용이라 서버 없이 목데이터로 표시함.
    let members: [HomeMember] = [
        HomeMember(name: "하륜영", isActive: true),
        HomeMember(name: "김수현", isActive: true),
        HomeMember(name: "이서연", isActive: false),
        HomeMember(name: "최준호", isActive: false)
    ]

}
