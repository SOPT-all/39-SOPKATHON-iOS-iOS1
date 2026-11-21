//
//  MatchBanner.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 우리 학교와 상대 학교를 사선으로 나눠 보여주는 VS 배너.
/// `myMembers`의 nil은 캐릭터 프로필로 표시함. 상대 팀은 인원수만큼 검정 원으로 표시함.
struct MatchBanner: View {

    let mySchool: String
    let opponentSchool: String
    let myMembers: [String?]
    let opponentCount: Int

    private let avatarSize: CGFloat = 43
    private let avatarStep: CGFloat = 34

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black

            Image(.imgVsShapeBack)
                .offset(x: 142)
            Image(.imgVsShapeFront)
                .offset(x: 153, y: -4)

            SchoolTag(title: mySchool, style: .onDark)
                .offset(x: 8, y: 7)
            SchoolTag(title: opponentSchool, style: .onLight)
                .offset(x: 192, y: 7)

            myAvatars
                .offset(x: 12, y: 39)
            opponentAvatars
                .frame(width: 335 - 13, alignment: .trailing)
                .offset(y: 39)
        }
        .frame(width: 335, height: 96)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

}

private extension MatchBanner {

    /// 왼쪽 멤버가 위에 오도록 겹쳐 배치함.
    var myAvatars: some View {
        let members = Array(myMembers.prefix(2).enumerated())
        return ZStack(alignment: .leading) {
            ForEach(members.reversed(), id: \.offset) { index, name in
                ProfileAvatar(name: name, size: avatarSize, style: .light)
                    .offset(x: CGFloat(index) * avatarStep)
            }
        }
    }

    /// 왼쪽 원이 위에 오도록 겹쳐 배치함.
    var opponentAvatars: some View {
        ZStack(alignment: .trailing) {
            ForEach(0..<min(opponentCount, 2), id: \.self) { index in
                Circle()
                    .fill(.black)
                    .overlay { Circle().stroke(.white, lineWidth: 2) }
                    .frame(width: avatarSize, height: avatarSize)
                    .offset(x: -CGFloat(index) * avatarStep)
            }
        }
    }

}
