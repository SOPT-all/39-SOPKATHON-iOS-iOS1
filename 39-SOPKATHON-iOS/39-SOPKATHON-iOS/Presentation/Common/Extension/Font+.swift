//
//  Font+.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import SwiftUI
import UIKit

/// Figma 디자인시스템의 Typography 스타일. 이름은 `역할/크기/굵기` 순서를 따름.
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

    case headerLBold
    case headerMBold
    case headerSBold
    case subHeaderLSemiBold
    case subHeaderMSemiBold
    case subHeaderSSemiBold
    case bodyLRegular
    case bodyLMedium
    case bodyLSemiBold
    case bodyMRegular
    case bodyMMedium
    case bodyMSemiBold
    case captionLRegular
    case captionLMedium
    case captionSRegular
    case captionSMedium

    var weight: Weight {
        switch self {
        case .headerLBold, .headerMBold, .headerSBold:
            .bold
        case .subHeaderLSemiBold, .subHeaderMSemiBold, .subHeaderSSemiBold,
             .bodyLSemiBold, .bodyMSemiBold:
            .semiBold
        case .bodyLMedium, .bodyMMedium, .captionLMedium, .captionSMedium:
            .medium
        case .bodyLRegular, .bodyMRegular, .captionLRegular, .captionSRegular:
            .regular
        }
    }

    var size: CGFloat {
        switch self {
        case .headerLBold: 28
        case .headerMBold: 24
        case .headerSBold: 22
        case .subHeaderLSemiBold: 20
        case .subHeaderMSemiBold: 18
        case .subHeaderSSemiBold, .bodyLRegular, .bodyLMedium, .bodyLSemiBold: 16
        case .bodyMRegular, .bodyMMedium, .bodyMSemiBold: 14
        case .captionLRegular, .captionLMedium: 12
        case .captionSRegular, .captionSMedium: 11
        }
    }

    /// Figma 기준 행간(px).
    var lineHeight: CGFloat {
        switch self {
        case .headerLBold: 38
        case .headerMBold: 34
        case .headerSBold: 30
        case .subHeaderLSemiBold: 28
        case .subHeaderMSemiBold: 26
        case .subHeaderSSemiBold, .bodyLRegular, .bodyLMedium, .bodyLSemiBold: 24
        case .bodyMRegular, .bodyMMedium, .bodyMSemiBold: 22
        case .captionLRegular, .captionLMedium: 18
        case .captionSRegular, .captionSMedium: 16
        }
    }

    var font: Font {
        .pretendard(weight, size: size)
    }

    /// Figma 행간에서 폰트 기본 행 높이를 뺀 줄 간격.
    var lineSpacing: CGFloat {
        let fontLineHeight = UIFont(name: weight.rawValue, size: size)?.lineHeight ?? size
        return max(lineHeight - fontLineHeight, 0)
    }

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

extension View {

    /// 폰트와 Figma 행간을 함께 적용함. 사용 예: .appFont(.bodyLRegular)
    /// Text에 직접 적용함. 여러 Text를 감싼 컨테이너에는 `.font(AppFont.xxx.font)` 사용.
    func appFont(_ style: AppFont) -> some View {
        font(style.font)
            .lineSpacing(style.lineSpacing)
            .padding(.vertical, style.lineSpacing / 2)
    }

}
