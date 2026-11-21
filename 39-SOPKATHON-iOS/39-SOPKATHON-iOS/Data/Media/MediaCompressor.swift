//
//  MediaCompressor.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/21/26.
//

import AVFoundation
import UIKit

/// 업로드 전에 촬영 결과를 줄여 앱 임시 폴더에 파일로 저장함.
/// 원본 파일은 지우지 않음. 반환한 파일과 원본은 업로드 후 호출한 쪽에서 삭제해야 함.
enum MediaCompressor {

    nonisolated private static let photoMaxPixelLength: CGFloat = 1920
    nonisolated private static let photoCompressionQuality: CGFloat = 0.8
    private static let videoExportPreset = AVAssetExportPreset1280x720

    static func compressedFileURL(for media: CapturedMedia) async throws -> URL {
        switch media {
        case .photo(let image):
            return try await compressPhoto(image)
        case .video(let url):
            return try await compressVideo(at: url)
        }
    }

    // 리사이즈·JPEG 인코딩이 메인 스레드를 오래 점유하지 않도록 분리함.
    @concurrent
    private static func compressPhoto(_ image: UIImage) async throws -> URL {
        let resizedImage = resize(image)
        guard let data = resizedImage.jpegData(
            compressionQuality: photoCompressionQuality
        ) else {
            throw MediaError.imageEncodingFailed
        }
        let outputURL = makeTemporaryFileURL(pathExtension: "jpg")
        try data.write(to: outputURL)
        return outputURL
    }

    nonisolated private static func resize(_ image: UIImage) -> UIImage {
        let pixelSize = CGSize(
            width: image.size.width * image.scale,
            height: image.size.height * image.scale
        )
        let longestLength = max(pixelSize.width, pixelSize.height)
        guard longestLength > photoMaxPixelLength else { return image }

        let ratio = photoMaxPixelLength / longestLength
        let targetSize = CGSize(
            width: (pixelSize.width * ratio).rounded(),
            height: (pixelSize.height * ratio).rounded()
        )
        // scale 1로 그려야 targetSize가 그대로 픽셀 크기가 됨.
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    private static func compressVideo(at sourceURL: URL) async throws -> URL {
        let asset = AVURLAsset(url: sourceURL)
        guard let session = AVAssetExportSession(
            asset: asset,
            presetName: videoExportPreset
        ) else {
            throw MediaError.videoExportFailed
        }
        session.shouldOptimizeForNetworkUse = true
        let outputURL = makeTemporaryFileURL(pathExtension: "mp4")

        do {
            if #available(iOS 18, *) {
                try await session.export(to: outputURL, as: .mp4)
            } else {
                try await exportOnIOS17(session, to: outputURL)
            }
            return outputURL
        } catch {
            // 실패·취소 시 남은 불완전한 파일은 지워도 되고, 지우기 실패는 결과에 영향 없음.
            try? FileManager.default.removeItem(at: outputURL)
            throw error
        }
    }

    // iOS 18 미만에는 export(to:as:)가 없어 기존 export()를 사용함.
    private static func exportOnIOS17(
        _ session: AVAssetExportSession,
        to outputURL: URL
    ) async throws {
        session.outputURL = outputURL
        session.outputFileType = .mp4
        await withTaskCancellationHandler {
            await session.export()
        } onCancel: {
            session.cancelExport()
        }
        try Task.checkCancellation()
        guard session.status == .completed else {
            throw session.error ?? MediaError.videoExportFailed
        }
    }

    nonisolated private static func makeTemporaryFileURL(pathExtension: String) -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(pathExtension)
    }

}
