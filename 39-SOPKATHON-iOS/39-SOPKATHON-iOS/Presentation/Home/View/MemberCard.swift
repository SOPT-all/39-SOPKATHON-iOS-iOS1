//
//  MemberCard.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 홈의 반 멤버 카드. 활성은 빨간 카드에 이름 프로필, 오프라인은 회색 카드에 캐릭터를 표시함.
/// 사용 예: MemberCard(name: "하륜영", isActive: true)
struct MemberCard: View {

    let name: String
    let isActive: Bool

    var body: some View {
        VStack(spacing: 6) {
            ProfileAvatar(
                name: isActive ? String(name.suffix(2)) : nil,
                size: 72,
                style: isActive ? .highlight : .inactive
            )

            VStack(spacing: 0) {
                Text(name)
                    .appFont(.bodyLSemiBold)
                    .lineLimit(1)
                Text(isActive ? "현재 활동 중" : "오프라인")
                    .appFont(.captionLRegular)
            }
            .foregroundStyle(.white)
        }
        .padding(.top, 15)
        .frame(width: 100, height: 146, alignment: .top)
        .background(isActive ? Color.mainRed : Color(hex: 0xD7D7D7))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

}
