//
//  HorseRaceTrack.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

/// 화면 높이에 맞춰 확대한 가로 트랙. progress(0...1)만큼 시작 위치에서 왼쪽으로 흘러 트랙 끝에서 멈춤.
struct HorseRaceTrack: View {

    let style: HorseRaceTrackStyle
    let progress: Double

    var body: some View {
        GeometryReader { proxy in
            let scale = proxy.size.height / HorseRaceTrackLayout.size.height
            let maxOffset = max(HorseRaceTrackLayout.size.width * scale - proxy.size.width, 0)
            let startOffset = min(style.startOffset * scale, maxOffset)

            content
                .frame(
                    width: HorseRaceTrackLayout.size.width,
                    height: HorseRaceTrackLayout.size.height
                )
                .scaleEffect(scale, anchor: .topLeading)
                .offset(x: -(startOffset + (maxOffset - startOffset) * progress))
        }
        .clipped()
        .animation(.easeOut(duration: 0.15), value: progress)
        .animation(.easeOut(duration: 0.3), value: style.startOffset)
    }

    private var content: some View {
        ZStack(alignment: .topLeading) {
            style.background

            HorseRaceLaneLines()
                .stroke(style.laneLine, lineWidth: HorseRaceTrackLayout.lineWidth)

            HorseRaceCurveLines()
                .stroke(style.curveLine, lineWidth: HorseRaceTrackLayout.lineWidth)

            ForEach(1...HorseRaceTrackLayout.laneCount, id: \.self) { lane in
                Text("\(lane)")
                    .font(.system(size: 70.475, weight: .bold))
                    .foregroundStyle(style.laneNumber)
                    .position(
                        x: HorseRaceTrackLayout.laneNumberX,
                        y: HorseRaceTrackLayout.laneNumberTop
                            + HorseRaceTrackLayout.laneHeight * CGFloat(lane - 1)
                    )
            }
        }
        .accessibilityHidden(true)
    }

}

struct HorseRaceTrackStyle {

    let background: Color
    let laneLine: Color
    let curveLine: Color
    let laneNumber: Color
    /// 트랙 프레임 기준 시작 위치. 진행 화면은 Figma처럼 레인 번호가 화면 밖에 있는 위치에서 시작함.
    let startOffset: CGFloat

    static let ready = HorseRaceTrackStyle(
        background: Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255),
        laneLine: Color(red: 156 / 255, green: 163 / 255, blue: 175 / 255).opacity(0.3),
        curveLine: Color(red: 156 / 255, green: 163 / 255, blue: 175 / 255).opacity(0.3),
        laneNumber: Color(red: 156 / 255, green: 163 / 255, blue: 175 / 255).opacity(0.3),
        startOffset: 0
    )

    static let running = HorseRaceTrackStyle(
        background: Color(red: 189 / 255, green: 67 / 255, blue: 56 / 255),
        laneLine: Color(red: 255 / 255, green: 244 / 255, blue: 232 / 255).opacity(0.2),
        curveLine: Color(red: 245 / 255, green: 201 / 255, blue: 185 / 255),
        laneNumber: Color(red: 255 / 255, green: 244 / 255, blue: 232 / 255),
        startOffset: 301
    )

}

/// Figma 트랙 프레임(2446.21 x 812) 기준 좌표. 도형은 이 크기로 그린 뒤 화면에 맞춰 확대함.
private enum HorseRaceTrackLayout {

    static let size = CGSize(width: 2446.21, height: 812)
    static let lineWidth: CGFloat = 7.14969
    static let laneCount = 6
    static let laneTop: CGFloat = 27.5774
    static let laneHeight: CGFloat = 126.141
    static let startLineX: CGFloat = 115.927
    static let laneNumberX: CGFloat = 57.71
    static let laneNumberTop: CGFloat = 90.65

}

private struct HorseRaceLaneLines: Shape {

    func path(in rect: CGRect) -> Path {
        let layout = HorseRaceTrackLayout.self
        let laneBottom = layout.laneTop + layout.laneHeight * CGFloat(layout.laneCount)

        var path = Path()
        for index in 0...layout.laneCount {
            let y = layout.laneTop + layout.laneHeight * CGFloat(index)
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: layout.size.width, y: y))
        }
        path.move(to: CGPoint(x: layout.startLineX, y: layout.laneTop))
        path.addLine(to: CGPoint(x: layout.startLineX, y: laneBottom))
        return path
    }

}

/// 트랙 오른쪽 곡선 구간. 좌표는 Figma SVG 경로를 그대로 옮김.
private struct HorseRaceCurveLines: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 1544.6, y: 0))
        path.addCurve(
            to: CGPoint(x: 1886.05, y: 550.776),
            control1: CGPoint(x: 1592.32, y: 217.139),
            control2: CGPoint(x: 1712.79, y: 411.461)
        )
        path.addCurve(
            to: CGPoint(x: 2497.28, y: 766.038),
            control1: CGPoint(x: 2059.31, y: 690.09),
            control2: CGPoint(x: 2274.96, y: 766.038)
        )

        path.move(to: CGPoint(x: 1415.8, y: 0))
        path.addCurve(
            to: CGPoint(x: 1647.06, y: 491.014),
            control1: CGPoint(x: 1450.73, y: 180.397),
            control2: CGPoint(x: 1530.23, y: 349.191)
        )
        path.addCurve(
            to: CGPoint(x: 2084.71, y: 812),
            control1: CGPoint(x: 1763.89, y: 632.836),
            control2: CGPoint(x: 1914.34, y: 743.181)
        )

        path.move(to: CGPoint(x: 1287.57, y: 0))
        path.addCurve(
            to: CGPoint(x: 1468.34, y: 460.34),
            control1: CGPoint(x: 1315.97, y: 164.121),
            control2: CGPoint(x: 1377.48, y: 320.745)
        )
        path.addCurve(
            to: CGPoint(x: 1816.09, y: 812),
            control1: CGPoint(x: 1559.2, y: 599.936),
            control2: CGPoint(x: 1677.52, y: 719.583)
        )

        path.move(to: CGPoint(x: 1159.73, y: 0))
        path.addCurve(
            to: CGPoint(x: 1608.65, y: 812),
            control1: CGPoint(x: 1209.05, y: 315.095),
            control2: CGPoint(x: 1368.04, y: 602.66)
        )

        path.move(to: CGPoint(x: 1032.18, y: 0))
        path.addCurve(
            to: CGPoint(x: 1426.24, y: 812),
            control1: CGPoint(x: 1075.79, y: 305.094),
            control2: CGPoint(x: 1213.55, y: 588.965)
        )

        path.move(to: CGPoint(x: 904.864, y: 0))
        path.addCurve(
            to: CGPoint(x: 1257.76, y: 812),
            control1: CGPoint(x: 944.098, y: 298.384),
            control2: CGPoint(x: 1066.38, y: 579.741)
        )

        path.move(to: CGPoint(x: 777.717, y: 0))
        path.addCurve(
            to: CGPoint(x: 1098.17, y: 812),
            control1: CGPoint(x: 813.466, y: 293.584),
            control2: CGPoint(x: 923.785, y: 573.127)
        )

        return path
    }

}
