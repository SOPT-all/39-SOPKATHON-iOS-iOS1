# 촬영·압축 공통 부품

촬영 화면을 만들 때 가져다 쓰는 부품 사용법임. 기술 선택 이유와 수치는 [기술 스택](tech-stack.md) 참고.

- 담당: SeongHwan
- 상태: 공통 부품 완료, 촬영 화면·업로드 미구현

## 주요 파일

| 파일 | 역할 |
| --- | --- |
| `Presentation/Common/Component/CameraPicker.swift` | 기본 카메라로 사진·영상 촬영. 결과를 `CapturedMedia`로 전달 |
| `Data/Media/CameraAuthorization.swift` | 촬영 전 카메라·마이크 권한 확인·요청 |
| `Data/Media/MediaCompressor.swift` | 업로드 전 압축 후 임시 파일 URL 반환 |
| `Data/Media/CapturedMedia.swift`, `MediaError.swift` | 촬영 결과 타입, 촬영·압축 오류 |
| `Application/SOPKATHON_iOSApp.swift` | 앱 시작 시 오디오 세션 `.playback` 설정 |

## 사용 흐름

1. `CameraPicker.isAvailable`로 카메라 유무 확인. `false`면 띄우지 않음(시뮬레이터에서 띄우면 앱 종료).
2. `await CameraAuthorization.requestAccess()`가 `false`면 설정 앱 이동 안내 표시
   (`UIApplication.openSettingsURLString`).
3. `CameraPicker(onComplete:onCancel:)`를 `.fullScreenCover`로 띄움. 두 콜백 모두에서 직접 닫아야 함.
4. `onComplete`의 `.success(media)`를 `try await MediaCompressor.compressedFileURL(for:)`에 넘김.
   영상 압축은 몇 초 걸리므로 로딩 표시와 실패 시 재시도가 필요함.
5. 반환한 파일 URL로 업로드함.

## 호출하는 쪽 책임

- 파일 정리: 압축 결과 파일과 `.video(URL)`의 원본 파일은 자동으로 지워지지 않음. 업로드 후 삭제해야 함.
- 취소: 압축을 실행한 `Task`를 취소하면 영상 압축도 중단되고 만들다 만 파일은 삭제됨.
- 오류: `onComplete`의 `.failure`와 압축 중 `throw`를 화면에서 안내해야 함.

## 주의·남은 일

- 실기기 미확인: 촬영, 10분 넘는 영상, 압축 결과 용량, 무음 모드 재생 소리.
- 카메라를 닫은 뒤 오디오 세션이 `.playback`으로 유지되는지 미확인. 바뀌면 재생 화면에서 다시 설정 필요.
- 촬영 중 질문 오버레이(`cameraOverlayView`)는 촬영 화면 구현 시 `CameraPicker`에 추가 필요.
- 업로드 방식·서버 최대 용량·사진/영상 구분 필드는 미정.
