//
//  MyPageView.swift
//  39-SOPKATHON-iOS
//
//  Created by Eda3399 on 11/22/26.
//

import SwiftUI

struct MyPageView: View {

    var body: some View {
        GeometryReader { geometry in
            let scale = max(
                geometry.size.width / MyPageLayout.canvasWidth,
                geometry.size.height / MyPageLayout.canvasHeight
            )

            MyPageCanvas()
                .frame(
                    width: MyPageLayout.canvasWidth,
                    height: MyPageLayout.canvasHeight
                )
                .scaleEffect(scale)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
        }
        .background(MyPageLayout.backgroundColor)
        .ignoresSafeArea()
    }

}

private struct MyPageCanvas: View {

    var body: some View {
        ZStack(alignment: .topLeading) {
            MyPageTrackBackground()

            Image(.mypageTitle)
                .resizable()
                .frame(width: 293.32, height: 195.75)
                .position(x: 183.48, y: 317.69)
                .accessibilityLabel("우리 반이 하나가 되는 온라인 운동회")

            Image(.mypageRunnerShadow)
                .resizable()
                .frame(width: 180.81, height: 191.52)
                .scaleEffect(x: 1, y: -1)
                .rotationEffect(.degrees(-90))
                .position(x: 159.67, y: 686.61)
                .accessibilityHidden(true)

            Image(.mypageRunner)
                .resizable()
                .frame(width: 56.25, height: 47.09)
                .scaleEffect(x: 1, y: -1)
                .rotationEffect(.degrees(-90))
                .position(x: 278.72, y: 612.15)
                .accessibilityHidden(true)
        }
        .frame(
            width: MyPageLayout.canvasWidth,
            height: MyPageLayout.canvasHeight
        )
        .clipped()
    }

}

private struct MyPageTrackBackground: View {

    private let curvePoints: [[CGPoint]] = [
        [
            CGPoint(x: -13, y: 341), CGPoint(x: 65, y: 394),
            CGPoint(x: 127, y: 425), CGPoint(x: 189, y: 452),
            CGPoint(x: 251, y: 474), CGPoint(x: 313, y: 489),
            CGPoint(x: 387, y: 502)
        ],
        [
            CGPoint(x: -13, y: 262), CGPoint(x: 65, y: 322),
            CGPoint(x: 127, y: 358), CGPoint(x: 189, y: 386),
            CGPoint(x: 251, y: 409), CGPoint(x: 313, y: 426),
            CGPoint(x: 387, y: 439)
        ],
        [
            CGPoint(x: -13, y: 179), CGPoint(x: 65, y: 247),
            CGPoint(x: 127, y: 287), CGPoint(x: 189, y: 319),
            CGPoint(x: 251, y: 343), CGPoint(x: 313, y: 362),
            CGPoint(x: 387, y: 376)
        ],
        [
            CGPoint(x: -13, y: 89), CGPoint(x: 65, y: 169),
            CGPoint(x: 127, y: 214), CGPoint(x: 189, y: 250),
            CGPoint(x: 251, y: 277), CGPoint(x: 313, y: 298),
            CGPoint(x: 387, y: 313)
        ],
        [
            CGPoint(x: -13, y: -13), CGPoint(x: 65, y: 85),
            CGPoint(x: 127, y: 138), CGPoint(x: 189, y: 179),
            CGPoint(x: 251, y: 210), CGPoint(x: 313, y: 233),
            CGPoint(x: 387, y: 250)
        ],
        [
            CGPoint(x: -13, y: -145), CGPoint(x: 65, y: -13),
            CGPoint(x: 127, y: 58), CGPoint(x: 189, y: 106),
            CGPoint(x: 251, y: 142), CGPoint(x: 313, y: 168),
            CGPoint(x: 387, y: 187)
        ],
        [
            CGPoint(x: -13, y: -330), CGPoint(x: 65, y: -121),
            CGPoint(x: 127, y: -30), CGPoint(x: 189, y: 29),
            CGPoint(x: 251, y: 72), CGPoint(x: 313, y: 101),
            CGPoint(x: 387, y: 124)
        ]
    ]

    var body: some View {
        Canvas { context, size in
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(MyPageLayout.backgroundColor)
            )

            drawLaneLines(in: &context, height: size.height)
            drawTrackCurves(in: &context)
        }
    }

    private func drawLaneLines(
        in context: inout GraphicsContext,
        height: CGFloat
    ) {
        var path = Path()

        for index in 0..<7 {
            let x = 0.58 + (CGFloat(index) * 62.14)
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: height))
        }

        context.stroke(
            path,
            with: .color(MyPageLayout.laneLineColor),
            lineWidth: 3.52
        )
    }

    private func drawTrackCurves(in context: inout GraphicsContext) {
        for points in curvePoints {
            context.stroke(
                makeSmoothPath(points),
                with: .color(MyPageLayout.curveLineColor),
                lineWidth: 3.52
            )
        }
    }

    private func makeSmoothPath(_ points: [CGPoint]) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }

        path.move(to: firstPoint)

        for index in 0..<(points.count - 1) {
            let previous = points[max(index - 1, 0)]
            let current = points[index]
            let next = points[index + 1]
            let following = points[min(index + 2, points.count - 1)]
            let firstControl = CGPoint(
                x: current.x + ((next.x - previous.x) / 6),
                y: current.y + ((next.y - previous.y) / 6)
            )
            let secondControl = CGPoint(
                x: next.x - ((following.x - current.x) / 6),
                y: next.y - ((following.y - current.y) / 6)
            )

            path.addCurve(
                to: next,
                control1: firstControl,
                control2: secondControl
            )
        }

        return path
    }

}

private enum MyPageLayout {

    static let canvasWidth: CGFloat = 375
    static let canvasHeight: CGFloat = 812

    static let backgroundColor = Color(
        red: 189 / 255,
        green: 46 / 255,
        blue: 32 / 255
    )

    static let laneLineColor = Color(
        red: 255 / 255,
        green: 244 / 255,
        blue: 232 / 255,
        opacity: 0.2
    )

    static let curveLineColor = Color(
        red: 245 / 255,
        green: 201 / 255,
        blue: 185 / 255,
        opacity: 0.2
    )

}

#Preview {
    MyPageView()
}
