//
//  HomeView.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import SwiftUI

struct HomeView: View {

    let onStartGame: () -> Void
    let onShowRanking: () -> Void

    @State private var viewModel = HomeViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.top, 21)

            // 시연 학급(1학년 1반) 고정 손글씨. 서버 학년·반은 요청 값으로만 사용함.
            Image(.imgTitleClass)
                .accessibilityLabel("1학년 1반 선수")
                .padding(.top, 22)
                .padding(.horizontal, 20)

            memberList
                .padding(.top, 16)

            Spacer(minLength: 0)

            PrimaryButton(title: "게임 시작하기", action: onStartGame)
                .padding(.horizontal, 20)
        }
        .background(alignment: .topLeading) {
            HomeBackground()
        }
        .toolbar(.hidden, for: .navigationBar)
        // 게임·랭킹에서 돌아올 때도 다시 조회해 멤버 목록을 갱신함.
        .task { await viewModel.fetchHome() }
        .alert("홈 정보를 불러오지 못했어요", isPresented: $viewModel.isShowingError) {
            Button("다시 시도") {
                Task { await viewModel.fetchHome() }
            }
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }

}

private extension HomeView {

    var header: some View {
        HStack(spacing: 18) {
            if !viewModel.myName.isEmpty {
                ProfileAvatar(name: String(viewModel.myName.suffix(2)), size: 48)
                SchoolTag(title: viewModel.schoolName)
            }

            Spacer(minLength: 0)

            // Figma `ic_ranking`: 48pt 터치 영역 가운데 막대 3개 그림.
            Button(action: onShowRanking) {
                Image(.icRanking)
                    .frame(width: 48, height: 48)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("랭킹")
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    var memberList: some View {
        if viewModel.members.isEmpty, viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
                .frame(height: 146)
        } else {
            memberScroll
        }
    }

    var memberScroll: some View {
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
    /// `img_home_runner_shadow` SVG 원본 크기. 에셋을 바꾸면 함께 수정함.
    private let shadowSize = CGSize(width: 200.426, height: 167.799)

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
        let center = CGPoint(x: shadowSize.width / 2, y: shadowSize.height / 2)
        let skew = CGAffineTransform(a: 1, b: 0, c: tan(-48 * .pi / 180), d: 1, tx: 0, ty: 0)
        return CGAffineTransform(translationX: -center.x, y: -center.y)
            .concatenating(skew)
            .concatenating(CGAffineTransform(rotationAngle: 45.32 * .pi / 180))
            .concatenating(CGAffineTransform(translationX: center.x, y: center.y))
    }

}
