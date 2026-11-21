//
//  SOPKATHON_iOSApp.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import AVFoundation
import OSLog
import SwiftUI

@main
struct SOPKATHON_iOSApp: App {
    init() {
        configureAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }

    // 무음 스위치를 켜도 영상 소리가 나도록 재생 카테고리로 설정함.
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            Logger().error("오디오 세션 설정 실패: \(error.localizedDescription)")
        }
    }
}
