# 기술 스택

릴레이(사진·영상 촬영 → 업로드 → 이어 붙이기) 기능의 기술 선택을 정리함.
라이브러리 버전·지원 범위는 2026-11-21에 공식 문서·GitHub 릴리스로 확인한 값임. 도입 시 다시 확인함.

## 서비스 구조 요약

- 릴레이 하나가 질문 하나를 공유함. 질문은 릴레이에 한 번만 저장하고 시작 후 수정 불가.
- 질문은 촬영 전에 직접 입력하거나 서비스가 제공한 질문 중 선택함. 음성 인식은 사용하지 않음.
- 각자 기기로 참여하는 반별 릴레이임. 참여 단위·순서·다음 반으로 이어지는 규칙과 인원 제한은
  기획 확정 후 결정함([서비스 기획](project.md) 참고).
- 질문 텍스트는 영상에 합성하지 않고 촬영·재생 화면 위에 겹쳐 표시함.

## 확정

| 영역 | 기술·방식 | 비고 |
| --- | --- | --- |
| 기반 | SwiftUI, 최소 iOS 17.0, Swift 5 모드 | 기존 프로젝트 설정 |
| 촬영 | `UIImagePickerController` (`UIViewControllerRepresentable`로 래핑) | `videoMaximumDuration` 기본값이 600초라 직접 제한 필요 |
| 촬영 중 질문 표시 | `cameraOverlayView` + `UIHostingController` | `.camera` 소스에서만 사용 가능. 촬영 버튼 터치를 막지 않게 `isUserInteractionEnabled = false` |
| 재생 | AVKit `VideoPlayer(player:videoOverlay:)` | 오버레이로 질문 표시 |
| 릴레이 넘겨 보기 | `TabView` + `.tabViewStyle(.page)` | 화면에 보이는 영상만 재생 |
| 네트워크 | `URLSession` async/await (기존 `BaseService`) | 영상은 파일로 저장 후 `upload(for:fromFile:)`. `Data`로 메모리에 올리지 않음 |
| 순서·참여 가능 판단 | 서버가 `order`, `canJoin` 결정 | 반별 참여 규칙·인원 제한이 정해져도 앱 수정 불필요 |
| 사용자 식별 | 온보딩 후 서버가 발급한 `userID`를 `@AppStorage`에 저장 | 인증 토큰 없음 |
| 재설치 | 새 사용자로 시작 | `UserDefaults`는 앱 삭제 시 지워짐. 이전 기록과 연결되지 않음 |
| 없는 사용자 응답 | `userID` 삭제 후 온보딩으로 이동 | 서버 DB 초기화 대비. 응답 코드는 서버와 협의 |
| 이미지 캐싱 | Kingfisher 8.x (`KFImage`), SPM으로 추가함 | iOS 17의 `AsyncImage`는 캐시가 문서화되지 않음(iOS 27부터 명시). 메모리·디스크 캐시와 다운샘플링 제공 |
| 권한 문구 | `Info.plist`의 `NSCameraUsageDescription`, `NSMicrophoneUsageDescription` | 문구 수정 시 `Info.plist`에서 변경 |

## 추천 (팀 합의 후 확정)

| 영역 | 추천 | 이유 |
| --- | --- | --- |
| 영상 압축 | `AVAssetExportSession`의 async `export(to:as:)` | `exportAsynchronously`는 iOS 18에서 deprecated. iOS 17 사용 가능 여부는 빌드로 확인 필요 |
| 새 영상 반영 | 화면 진입·당겨서 새로고침 시 재조회 | 실시간 연결보다 작업량이 적음 |
| 영상 썸네일 | 서버가 썸네일 URL 제공 | 이미지 라이브러리의 영상 첫 장면 추출 기능은 확인되지 않음 |
| 공유 | `ShareLink`로 시작 | 카카오톡 공유는 시간이 남을 때 추가 |

## 사용하지 않음

| 대상 | 이유 |
| --- | --- |
| `Speech` (음성 인식) | 질문을 텍스트로 받기로 함 |
| Keychain 래퍼, KeychainAccess | 인증 토큰이 없어 효과 없음. KeychainAccess는 2021년 이후 릴리스 없음 |
| Alamofire, Moya | `URLSession`으로 충분함. Moya는 2022년 이후 릴리스 없음 |
| Starscream | 실시간 기능 미사용. 2024년 3월 이후 커밋 없음 |
| MijickCamera 등 카메라 라이브러리 | 기본 기능으로 충분함. 마지막 릴리스 2025년 9월 |
| NextLevelSessionExporter | 비트레이트 세부 조절이 필요할 때만 검토 |

## 미정

| 항목 | 영향 |
| --- | --- |
| 업로드 방식 (multipart 또는 presigned URL) | 앱 업로드 코드. presigned URL이면 multipart 불필요 |
| 영상 최대 길이·용량, 압축 화질 | 업로드 시간, 서버 용량 |
| 사진 허용, 갤러리 업로드 허용 여부 | 촬영 화면 구성 |
| 반별 릴레이 참여 단위·순서·다음 반 연결 규칙, 인원 제한 | 서버 `canJoin` 조건, 릴레이 화면 구성 |
| 릴레이 진입 경로 (앱 내 목록, 공유 링크, 카카오) | 화면 구성, Kakao SDK 도입 여부 |
| 서비스 질문 제공 방식 (오늘의 질문, 추천 목록) | 질문 선택 화면, API |
| 푸시 알림 | 유료 Apple Developer Program, 서버 푸시 기능 필요 |
| 유료 개발자 계정 | 무료 계정은 기기 3대, 7일마다 재설치, TestFlight 불가 |
| `userID` 타입과 요청 내 위치 | 서버 명세로 확정 |

## 선택 시 참고할 외부 조건

- **Kakao SDK** (2.30.0): Xcode 26 이상, iOS 15 이상. 의존성으로 Alamofire가 함께 설치됨. 네이티브 앱 키와
  URL Scheme(`kakao{NATIVE_APP_KEY}`) 설정 필요. 수신자 앱 미설치 시 동작은 공식 문서에서 확인하지 못함.
- **Firebase** (13.2.0, 자체 서버 대신 쓸 때만): Xcode 26.2 이상. Cloud Storage는 Blaze(종량제) 요금제 필수.
  FCM은 APNs 키와 유료 개발자 계정 필요.
- **유료 개발자 계정이 필요한 기능**: 푸시 알림, TestFlight, Sign in with Apple, Associated Domains(Universal Links).

## 준비 사항

- 시뮬레이터에는 카메라가 없음. 촬영 기능은 실기기로만 확인 가능함.
- Kingfisher·Kakao SDK·Firebase는 Xcode 26 이상 필요. 팀원 Xcode 버전 확인 필요.
- 서버 팀과 먼저 맞출 것: 업로드 방식, `canJoin`, 없는 사용자 응답 형식, 썸네일 URL, `userID` 타입.

## 출처

- [UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller),
  [cameraOverlayView](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/cameraoverlayview)
- [VideoPlayer](https://developer.apple.com/documentation/avkit/videoplayer),
  [AsyncImage](https://developer.apple.com/documentation/swiftui/asyncimage)
- [AVAssetExportSession export(to:as:isolation:)](https://developer.apple.com/documentation/avfoundation/avassetexportsession/export(to:as:isolation:))
- [URLSession upload(for:fromFile:delegate:)](https://developer.apple.com/documentation/foundation/urlsession/upload(for:fromfile:delegate:))
- [Kingfisher](https://github.com/onevcat/Kingfisher), [Nuke](https://github.com/kean/Nuke),
  [Alamofire](https://github.com/Alamofire/Alamofire)
- [Kakao SDK 시작하기](https://developers.kakao.com/docs/latest/ko/ios/getting-started),
  [Firebase iOS 설정](https://firebase.google.com/docs/ios/setup)
- [Apple 멤버십 비교](https://developer.apple.com/support/compare-memberships/),
  [iOS 지원 capability](https://developer.apple.com/help/account/reference/supported-capabilities-ios/)
