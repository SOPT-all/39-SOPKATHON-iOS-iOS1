//
//  HomeView.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel = HomeViewModel()
    @State private var isGameRoomPresented = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.top, 21)

                Image(.imgTitleClass)
                    .padding(.top, 22)
                    .padding(.horizontal, 20)

                memberList
                    .padding(.top, 16)

                Spacer(minLength: 0)

                PrimaryButton(title: "게임 시작하기") {
                    isGameRoomPresented = true
                }
                .padding(.horizontal, 20)
            }
            .background(alignment: .topLeading) {
                HomeBackground()
            }
            .navigationDestination(isPresented: $isGameRoomPresented) {
                GameRoomView()
            }
        }
    }

}

private extension HomeView {

    var header: some View {
        HStack(spacing: 18) {
            ProfileAvatar(name: viewModel.myName, size: 48)
            SchoolTag(title: viewModel.schoolName)

            Spacer(minLength: 0)

            Image(.icRanking)
        }
        .padding(.leading, 20)
        .padding(.trailing, 10)
    }

    var memberList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.members) { member in
                    MemberCard(name: member.name, isActive: member.isActive)
                }
            }
            .padding(.horizontal, 20)
        }
    }

}

/// 홈 배경의 트랙과 달리는 사람. Figma 375 x 812 프레임 좌표로 배치하고 화면 폭에 맞춰 확대함.
private struct HomeBackground: View {

    private let figmaWidth: CGFloat = 375

    var body: some View {
        GeometryReader { proxy in
            figmaLayout
                .scaleEffect(proxy.size.width / figmaWidth, anchor: .topLeading)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var figmaLayout: some View {
        ZStack(alignment: .topLeading) {
            Image(.imgHomeTrack)
                .offset(x: -29, y: 202)

            // Figma: -skew-x-48, rotate 45.32°
            Image(.imgHomeRunnerShadow)
                .transformEffect(shadowTransform)
                .frame(width: 308.4, height: 152.2)
                .offset(x: 157, y: 614.3)

            // Figma: 좌우 반전 후 -15° 회전
            Image(.imgHomeRunner)
                .scaleEffect(x: -1)
                .rotationEffect(.degrees(-15))
                .frame(width: 66.5, height: 60)
                .offset(x: 192, y: 564)
        }
        .frame(width: figmaWidth, height: 812, alignment: .topLeading)
    }

    /// 그림자 이미지 중심을 기준으로 기울인 뒤 회전함.
    private var shadowTransform: CGAffineTransform {
        let center = CGPoint(x: 200.426 / 2, y: 167.799 / 2)
        let skew = CGAffineTransform(a: 1, b: 0, c: tan(-48 * .pi / 180), d: 1, tx: 0, ty: 0)
        return CGAffineTransform(translationX: -center.x, y: -center.y)
            .concatenating(skew)
            .concatenating(CGAffineTransform(rotationAngle: 45.32 * .pi / 180))
            .concatenating(CGAffineTransform(translationX: center.x, y: center.y))
    }

}
