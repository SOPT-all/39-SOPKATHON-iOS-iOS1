//
//  GameCard.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 게임방의 종목 선택 카드. 사용 예: GameCard(game: .horseRace, isSelected: true) { }
/// `isEnabled`가 false면 탭만 막고, 버튼은 Figma 회색 상태 그대로 보여줌.
struct GameCard: View {

    let game: Game
    let isSelected: Bool
    var isEnabled = true
    let onSelect: () -> Void

    var body: some View {
        Color(hex: 0xC8C8C8)
            .frame(height: 200)
            .overlay(alignment: .topLeading) { backgroundImage }
            .overlay(alignment: .topLeading) {
                backgroundImage
                    .blur(radius: 14)
                    .mask(alignment: .topLeading) { infoArea }
            }
            .overlay(alignment: .topLeading) {
                LinearGradient(
                    colors: [.clear, gradientEndColor],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: infoAreaHeight)
                .offset(y: infoAreaTop)
                .allowsHitTesting(false)
            }
            .overlay(alignment: .topLeading) { content }
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

}

private extension GameCard {

    /// Figma에서 배경 이미지를 카드보다 크게 두고 일부만 보이도록 배치한 값.
    var imageLayout: (image: ImageResource, size: CGSize, offset: CGSize) {
        switch game {
        case .horseRace:
            (.imgGameRelay, CGSize(width: 1331, height: 442), CGSize(width: -224, height: -142))
        case .tugOfWar:
            (.imgGameTug, CGSize(width: 2048, height: 680), CGSize(width: -857, height: -286))
        }
    }

    var gradientEndColor: Color {
        switch game {
        case .horseRace: .black
        case .tugOfWar: Color(hex: 0x4E3718)
        }
    }

    /// 카드보다 큰 이미지라 잘린 바깥 영역이 다른 카드의 터치를 가로채지 않게 터치를 막음.
    var backgroundImage: some View {
        Image(imageLayout.image)
            .resizable()
            .scaledToFill()
            .frame(width: imageLayout.size.width, height: imageLayout.size.height)
            .offset(imageLayout.offset)
            .allowsHitTesting(false)
    }

    /// Figma `Frame 200`(블러·그라데이션 영역)의 카드 내 위치.
    var infoAreaTop: CGFloat { 34 }

    var infoAreaHeight: CGFloat { 166 }

    /// 하단 블러 영역의 마스크. 위쪽은 선명하게 두고 아래로 갈수록 블러가 진해지게 함.
    var infoArea: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: 0.3)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(maxWidth: .infinity)
        .frame(height: infoAreaHeight)
        .offset(y: infoAreaTop)
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .appFont(.subHeaderLSemiBold)
                Text(game.description)
                    .appFont(.bodyMRegular)
            }
            .foregroundStyle(.white)

            Button(action: onSelect) {
                Text("이 게임 할래요")
                    .font(AppFont.bodyLSemiBold.font)
                    .foregroundStyle(isSelected ? .white : Color(hex: 0x767676))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(isSelected ? Color.mainRed : Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .buttonStyle(.plain)
            // .disabled는 버튼을 반투명하게 흐려 배경이 비쳐 보이므로 탭만 막음.
            .allowsHitTesting(isEnabled)
            .padding(.top, 4)
        }
        .padding(.horizontal, 11)
        .padding(.top, infoAreaTop + 46)
    }

}
