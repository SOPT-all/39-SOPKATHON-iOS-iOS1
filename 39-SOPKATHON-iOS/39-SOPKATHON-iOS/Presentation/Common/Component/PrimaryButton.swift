//
//  PrimaryButton.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 화면 하단의 주요 버튼. 사용 예: PrimaryButton(title: "준비 완료", isEnabled: isFull) { }
struct PrimaryButton: View {

    let title: String
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.subHeaderSSemiBold.font)
                .foregroundStyle(isEnabled ? .white : Palette.disabledText)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(isEnabled ? .mainRed : Palette.disabledBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    if !isEnabled {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Palette.disabledBorder, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

}

private extension PrimaryButton {

    /// Figma `bt` 비활성(di) 상태 색상. 디자인시스템 토큰에 없는 값임.
    enum Palette {
        static let disabledBackground = Color(hex: 0xEBEBEB)
        static let disabledBorder = Color(hex: 0xCACACA)
        static let disabledText = Color(hex: 0xB4B4B4)
    }

}
