# 기술 스택

앱의 기술 선택을 정리함.
라이브러리 버전·지원 범위는 2026-11-21에 공식 문서·GitHub 릴리스로 확인한 값임. 도입 시 다시 확인함.

## 확정

| 영역 | 기술·방식 | 비고 |
| --- | --- | --- |
| 기반 | SwiftUI, 최소 iOS 17.0, Swift 5 모드 | 기존 프로젝트 설정 |
| 네트워크 | `URLSession` async/await (기존 `BaseService`) | |
| 사용자 식별 | 온보딩 후 서버가 발급한 `userID`를 `@AppStorage`에 저장 | 인증 토큰 없음 |
| 재설치 | 새 사용자로 시작 | `UserDefaults`는 앱 삭제 시 지워짐. 이전 기록과 연결되지 않음 |
| 없는 사용자 응답 | `userID` 삭제 후 온보딩으로 이동 | 서버 DB 초기화 대비. 응답 코드는 서버와 협의 |
| 권한 문구 | `Info.plist`의 `NSMicrophoneUsageDescription` | 문구 수정 시 `Info.plist`에서 변경 |

## 추천 (팀 합의 후 확정)

| 영역 | 추천 | 이유 |
| --- | --- | --- |
| 공유 | `ShareLink`로 시작 | 카카오톡 공유는 시간이 남을 때 추가 |

## 사용하지 않음

| 대상 | 이유 |
| --- | --- |
| `Speech` (음성 인식) | 질문을 텍스트로 받기로 함 |
| Keychain 래퍼, KeychainAccess | 인증 토큰이 없어 효과 없음. KeychainAccess는 2021년 이후 릴리스 없음 |
| Alamofire, Moya | `URLSession`으로 충분함. Moya는 2022년 이후 릴리스 없음 |
| Starscream | 실시간 기능 미사용. 2024년 3월 이후 커밋 없음 |

## 미정

| 항목 | 영향 |
| --- | --- |
| 앱 진입 경로 (앱 내 목록, 공유 링크, 카카오) | 화면 구성, Kakao SDK 도입 여부 |
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

- Kakao SDK·Firebase는 Xcode 26 이상 필요. 팀원 Xcode 버전 확인 필요.
- 서버 팀과 먼저 맞출 것: 없는 사용자 응답 형식, `userID` 타입.

## 출처

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Kakao SDK 시작하기](https://developers.kakao.com/docs/latest/ko/ios/getting-started),
  [Firebase iOS 설정](https://firebase.google.com/docs/ios/setup)
- [Apple 멤버십 비교](https://developer.apple.com/support/compare-memberships/),
  [iOS 지원 capability](https://developer.apple.com/help/account/reference/supported-capabilities-ios/)
