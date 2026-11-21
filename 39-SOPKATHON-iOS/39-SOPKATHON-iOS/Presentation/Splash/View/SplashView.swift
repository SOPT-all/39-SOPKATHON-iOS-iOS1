//
//  SplashView.swift
//  39-SOPKATHON-iOS
//
//  Created by Eda3399 on 11/22/26.
//

import SwiftUI

import Lottie

/// 앱 시작 화면. `splash-intro` Lottie(375x812, 3초)를 한 번 재생함.
/// 러너가 제목을 지나가며 글자가 하얘지고, 흰 화면에 banana 로고가 나타나는 흐름이 모두 들어 있음.
struct SplashView: View {

    /// 재생이 끝나면 호출함.
    let onFinish: () -> Void

    /// Lottie 재생 시간(3초)보다 조금 길게 둔 대비 시간.
    private let fallbackDuration: Duration = .seconds(3.5)

    var body: some View {
        LottieView(animation: .named("splash-intro"))
            .playing(loopMode: .playOnce)
            .animationDidFinish { _ in onFinish() }
            .resizable()
            // 기기 비율이 375x812와 달라도 빈 여백이 생기지 않게 화면을 채움.
            .configure(\.contentMode, to: .scaleAspectFill)
            .ignoresSafeArea()
            .background(Color.white.ignoresSafeArea())
            .accessibilityElement()
            .accessibilityLabel("우리 반이 하나가 되는 온라인 운동회, banana")
            .task {
                // Lottie 완료 알림이 오지 않는 경우(리소스 로드 실패 등)에도 홈으로 넘어가도록 대비함.
                do {
                    try await Task.sleep(for: fallbackDuration)
                } catch {
                    // 화면이 사라져 취소된 경우라 전환하지 않음.
                    return
                }
                onFinish()
            }
    }

}
