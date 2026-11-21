//
//  CameraPicker.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/21/26.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

/// 카메라로 사진·영상을 촬영하는 화면.
/// 카메라가 없는 기기(시뮬레이터)에서 띄우면 앱이 종료되므로 `isAvailable`을 먼저 확인해야 함.
struct CameraPicker: UIViewControllerRepresentable {

    static var isAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    // 길이 제한을 두지 않기로 함. 기본값 600초 제한을 풀기 위해 충분히 큰 값(1시간) 사용함.
    private static let videoMaximumDuration: TimeInterval = 60 * 60

    let onComplete: (Result<CapturedMedia, any Error>) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
        picker.videoQuality = .typeHigh
        picker.videoMaximumDuration = Self.videoMaximumDuration
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {
        context.coordinator.parent = self
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

}

extension CameraPicker {

    final class Coordinator: NSObject {

        var parent: CameraPicker

        init(parent: CameraPicker) {
            self.parent = parent
        }

        fileprivate func makeCapturedMedia(
            from info: [UIImagePickerController.InfoKey: Any]
        ) throws -> CapturedMedia {
            if let image = info[.originalImage] as? UIImage {
                return .photo(image)
            }
            guard let videoURL = info[.mediaURL] as? URL else {
                throw MediaError.missingCapturedMedia
            }
            // 피커가 만든 임시 파일은 피커가 사라진 뒤 지워질 수 있어 앱 임시 폴더로 옮김.
            let movedURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(videoURL.pathExtension)
            try FileManager.default.moveItem(at: videoURL, to: movedURL)
            return .video(movedURL)
        }

    }

}

extension CameraPicker.Coordinator: UIImagePickerControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        do {
            parent.onComplete(.success(try makeCapturedMedia(from: info)))
        } catch {
            parent.onComplete(.failure(error))
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.onCancel()
    }

}

// UIImagePickerController.delegate 타입이 요구해서 채택함. 구현할 메서드는 없음.
extension CameraPicker.Coordinator: UINavigationControllerDelegate {}
