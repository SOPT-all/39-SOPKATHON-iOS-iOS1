//
//  TopNavi.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 뒤로가기와 타이틀이 있는 상단 바. Figma `top_navi`.
/// 사용 예: TopNavi(title: "매칭 완료!") { dismiss() }
struct TopNavi: View {

    let title: String
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image(.icBack)
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.plain)

            Text(title)
                .appFont(.headerSBold)
                .foregroundStyle(Color(hex: 0x191914))

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(.white)
    }

}
