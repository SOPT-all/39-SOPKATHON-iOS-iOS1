//
//  CameraAuthorization.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/21/26.
//

import AVFoundation

enum CameraAuthorization {

    /// 카메라 권한이 있으면 true 반환함. 처음 요청이면 시스템 권한 창을 띄움.
    /// false면 거부·제한 상태이므로 설정 앱 이동 안내가 필요함.
    static func requestAccess() async -> Bool {
        guard await requestAccess(for: .video) else { return false }
        // 사진은 마이크 없이도 찍을 수 있어야 하므로 마이크는 요청만 하고 결과에 반영하지 않음.
        _ = await requestAccess(for: .audio)
        return true
    }

    private static func requestAccess(for mediaType: AVMediaType) async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: mediaType)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }

}
