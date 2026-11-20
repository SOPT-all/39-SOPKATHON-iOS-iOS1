//
//  Font+.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import SwiftUI

enum AppFont {
    enum Weight: String {
        case thin = "Pretendard-Thin"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case black = "Pretendard-Black"
    }

    // 임시 공통 스타일, 디자인 확정 후 이름, 굵기, 크기를 수정
    static let title: Font = .pretendard(.bold, size: 24)
    static let body: Font = .pretendard(.regular, size: 16)
    static let caption: Font = .pretendard(.regular, size: 12)
}

extension Font {
    /// 사용 예: .font(.pretendard(.semiBold, size: 18))
    static func pretendard(
        _ weight: AppFont.Weight = .regular,
        size: CGFloat
    ) -> Font {
        .custom(weight.rawValue, fixedSize: size)
    }
}
