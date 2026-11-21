//
//  GameCard.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 게임방의 종목 선택 카드. 카드 전체를 탭해 종목을 고름.
/// 사용 예: GameCard(game: .horseRace, status: .available) { select(.horseRace) }
struct GameCard: View {

    enum Status {
        /// 양 팀 준비 전: 회색 이미지, 흐리게, 탭 불가
        case locked
        /// 선택 가능: 회색 이미지
        case available
        /// 선택됨: 컬러 이미지와 "당선" 배지
        case selected
        /// 다른 종목이 선택됨: 회색 이미지, 탭 불가
        case unselected
    }

    let game: Game
    let status: Status
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            card
        }
        .buttonStyle(.plain)
        .allowsHitTesting(status == .available)
        .overlay(alignment: .topLeading) {
            if status == .selected {
                Image(.imgBadgeSelected)
                    .offset(x: 204.75, y: 4.75)
                    .transition(.scale(scale: 0.3).combined(with: .opacity))
                    .allowsHitTesting(false)
            }
        }
        .opacity(status == .locked ? 0.2 : 1)
        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: status)
    }

}

private extension GameCard {

    var card: some View {
        Color(hex: 0xC8C8C8)
            .frame(height: 162)
            .overlay(alignment: .topLeading) { backgroundImage }
            .overlay(alignment: .topLeading) {
                backgroundImage
                    .blur(radius: 14)
                    .mask(alignment: .topLeading) { infoArea }
            }
            .overlay(alignment: .topLeading) {
                LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                    .frame(height: infoAreaHeight)
                    .offset(y: infoAreaTop)
                    .allowsHitTesting(false)
            }
            .overlay(alignment: .topLeading) { content }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
    }

    /// 선택된 종목만 컬러 이미지, 나머지는 회색 이미지(Figma 홈-6·7 기준).
    var image: ImageResource {
        switch (game, status == .selected) {
        case (.horseRace, true): .imgGameRelay
        case (.horseRace, false): .imgGameRelayGray
        case (.tugOfWar, true): .imgGameTug
        case (.tugOfWar, false): .imgGameTugGray
        }
    }

    var titleImage: ImageResource {
        switch game {
        case .horseRace: .imgTitleRelay
        case .tugOfWar: .imgTitleTug
        }
    }

    /// Figma에서 배경 이미지를 카드보다 크게 두고 일부만 보이도록 배치한 값.
    var imageLayout: (size: CGSize, offset: CGSize) {
        switch game {
        case .horseRace:
            (CGSize(width: 1331, height: 442), CGSize(width: -224, height: -142))
        case .tugOfWar:
            (CGSize(width: 2048, height: 680), CGSize(width: -857, height: -286))
        }
    }

    /// 카드보다 큰 이미지라 잘린 바깥 영역이 다른 카드의 터치를 가로채지 않게 터치를 막음.
    var backgroundImage: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: imageLayout.size.width, height: imageLayout.size.height)
            .offset(imageLayout.offset)
            .allowsHitTesting(false)
    }

    /// Figma `Frame 200`(블러·그라데이션 영역)의 카드 내 위치.
    var infoAreaTop: CGFloat { 40 }

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
        VStack(alignment: .leading, spacing: 4) {
            Image(titleImage)
                .accessibilityLabel(game.title)
            Text(game.description)
                .appFont(.bodyMRegular)
                .foregroundStyle(.white)
        }
        .padding(.leading, 11)
        .padding(.top, infoAreaTop + 59)
        .allowsHitTesting(false)
    }

}
