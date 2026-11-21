//
//  RankingView.swift
//  39-SOPKATHON-iOS
//
//  Created by Eda3399 on 11/22/26.
//

import SwiftUI

struct RankingView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedScope: RankingScope = .nationwide

    var body: some View {
        VStack(spacing: 0) {
            TopNavi(title: "홈") {
                dismiss()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    scopeSelector

                    RankingPodium(items: RankingData.podiumItems)
                        .padding(.top, 26)

                    LazyVStack(spacing: 11) {
                        ForEach(RankingData.listItems) { item in
                            RankingRow(item: item)
                        }
                    }
                    .padding(.top, 26)

                    Color.clear
                        .frame(height: 160)
                }
                .padding(.horizontal, 20)
            }
        }
        .background(.white)
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [
                    Color(hex: 0xD9D9D9, opacity: 0),
                    Color(hex: 0x737373, opacity: 0.4)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 208)
            .ignoresSafeArea(edges: .bottom)
            .allowsHitTesting(false)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var scopeSelector: some View {
        HStack(spacing: 0) {
            ForEach(RankingScope.allCases) { scope in
                Button {
                    selectedScope = scope
                } label: {
                    Text(scope.title)
                        .appFont(
                            selectedScope == scope
                                ? .bodyLSemiBold
                                : .bodyLMedium
                        )
                        .foregroundStyle(
                            selectedScope == scope
                                ? Color.white
                                : Color(hex: 0x676767)
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            if selectedScope == scope {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.grey10)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .frame(height: 60)
        .background(Color(hex: 0xF2F2F2), in: .rect(cornerRadius: 4))
    }

}

private struct RankingPodium: View {

    let items: [PodiumRankingItem]

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(items) { item in
                VStack(spacing: 6) {
                    Image(item.schoolLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)

                    Text(item.schoolName)
                        .appFont(.captionSMedium)
                        .foregroundStyle(Color(hex: 0x545454))
                        .lineLimit(1)

                    Text("\(item.score)점")
                        .appFont(.bodyMSemiBold)
                        .foregroundStyle(.black)

                    Rectangle()
                        .fill(item.barColor)
                        .frame(height: item.barHeight)
                        .overlay {
                            Image(item.rankImage)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: 24,
                                    height: item.rankImageHeight
                                )
                        }
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 4,
                                topTrailingRadius: 4
                            )
                        )
                }
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    "\(item.rank)위 \(item.schoolName), \(item.score)점"
                )
            }
        }
        .frame(height: 220, alignment: .bottom)
    }

}

private struct RankingRow: View {

    let item: RankingListItem

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                Text("\(item.rank)")
                    .foregroundStyle(Color(hex: 0x6C6C6C))

                Text(item.schoolName)
                    .foregroundStyle(.black)
            }

            Spacer(minLength: 8)

            HStack(spacing: 6) {
                Text("\(item.score) 점")
                    .foregroundStyle(.black)

                HStack(spacing: 4) {
                    Image(.rankingRankDown)
                        .rotationEffect(.degrees(180))
                        .frame(width: 15, height: 15)

                    Text("\(item.change)")
                        .foregroundStyle(Color(hex: 0x1A4196))
                }
            }
        }
        .font(AppFont.bodyLSemiBold.font)
        .padding(.horizontal, 19)
        .frame(height: 61)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.grey1)
                .frame(height: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(item.rank)위 \(item.schoolName), \(item.score)점, "
                + "순위 \(item.change)단계 하락"
        )
    }

}

private enum RankingScope: CaseIterable, Identifiable {

    case nationwide
    case school

    var id: Self { self }

    var title: String {
        switch self {
        case .nationwide:
            "전국 학교 랭킹"
        case .school:
            "우리 학교 랭킹"
        }
    }

}

private struct PodiumRankingItem: Identifiable {

    let rank: Int
    let schoolName: String
    let score: Int
    let schoolLogo: ImageResource
    let rankImage: ImageResource
    let rankImageHeight: CGFloat
    let barHeight: CGFloat
    let barColor: Color

    var id: Int { rank }

}

private struct RankingListItem: Identifiable {

    let rank: Int
    let schoolName: String
    let score: Int
    let change: Int

    var id: Int { rank }

}

private enum RankingData {

    static let podiumItems = [
        PodiumRankingItem(
            rank: 2,
            schoolName: "부디고등학교",
            score: 110,
            schoolLogo: .rankingSchoolLogoSecond,
            rankImage: .rankingRankSecond,
            rankImageHeight: 26.446,
            barHeight: 92,
            barColor: Color(hex: 0xDF5346)
        ),
        PodiumRankingItem(
            rank: 1,
            schoolName: "솝트고등학교",
            score: 120,
            schoolLogo: .rankingSchoolLogoFirst,
            rankImage: .rankingRankFirst,
            rankImageHeight: 35.487,
            barHeight: 120,
            barColor: .mainRed
        ),
        PodiumRankingItem(
            rank: 3,
            schoolName: "솝트중학교",
            score: 100,
            schoolLogo: .rankingSchoolLogoThird,
            rankImage: .rankingRankThird,
            rankImageHeight: 26.446,
            barHeight: 68,
            barColor: Color(hex: 0xFDA097)
        )
    ]

    static let listItems = [
        RankingListItem(
            rank: 4,
            schoolName: "사등고등학교",
            score: 80,
            change: 1
        ),
        RankingListItem(
            rank: 5,
            schoolName: "오등중학교",
            score: 80,
            change: 1
        ),
        RankingListItem(
            rank: 6,
            schoolName: "육등고등학교",
            score: 80,
            change: 1
        ),
        RankingListItem(
            rank: 7,
            schoolName: "칠등고등학교",
            score: 80,
            change: 1
        ),
        RankingListItem(
            rank: 8,
            schoolName: "팔등초등학교",
            score: 80,
            change: 1
        ),
        RankingListItem(
            rank: 9,
            schoolName: "일등고등학교",
            score: 80,
            change: 1
        )
    ]

}
