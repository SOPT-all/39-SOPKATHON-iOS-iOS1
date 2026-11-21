# 네트워크

프로젝트 작업 원칙과 비밀값 규칙은 [AGENTS.md](../AGENTS.md#보안) 참고.

## 구성

- URLSession·async/await 기반 `BaseService` 사용. `EndPoint`에서 경로·메서드·쿼리·헤더 정의함.
- Swagger 공통 응답은 `status(Int)·code(String)·message(String)·data(T?)`임.
- HTTP 상태와 본문의 `status`가 모두 2xx이면 성공 처리함. `code`는 API별로 다르므로
  단일 성공 문자열과 비교하지 않음. 성공 응답에 `data`가 없으면 `NetworkError.noData` 발생함.
- 실패 HTTP 응답에서는 `code`를 `NetworkError.serverCode`로 확인 가능함.
- 멤버 식별이 필요한 EndPoint는 `memberID`를 인자로 받고 `X-Demo-Member-Id` 헤더에 전달함.
  `gameType`·`voiceResult` 조회에는 해당 헤더가 필요하지 않음. 임의의 기본 멤버 ID는 두지 않음.
- 요청·응답 본문은 로그에 출력하지 않으며 멤버 식별 헤더는 마스킹함.
- 공통 코드·DTO 위치는 [폴더 구조](structure-assets.md#폴더-구조) 따름.
- 새 네트워크 라이브러리는 팀 합의 없이 도입하지 않음.

## 연동 기준

- API 연동 전 성공 코드·응답 DTO·디코딩·콘텐츠 타입·인증을 서버 명세와 맞추고 완료한 TODO는 제거함.
- 통신·HTTP·디코딩·취소 오류를 구분함.

## BASE_URL 설정

- 주소는 `BASE_URL`로 전달함. `Info.plist`의 `BASE_URL` 항목이 빌드 설정 `$(BASE_URL)`을 참조하고
  `BaseService`가 이 값을 읽음.
- TODO: xcconfig 파일 이름·위치·Xcode 연결 방법은 미정임. 팀에서 xcconfig 구성을 확정하면 이 절에 추가 필요.
- 미정인 동안 AI는 xcconfig 파일을 임의로 만들거나 프로젝트에 연결하지 않고 사용자에게 확인함.

## 사용 방법

- `EndPoint`는 Swagger의 홈·준비·종목·기록 제출·상태·결과 API 11개를 정의함.
- 요청 body와 응답 DTO는 각 화면 연동 담당자가 명세에 맞춰 추가함.
- ViewModel에서 필요한 ID를 전달하고, 취소와 오류를 해당 화면 상태로 처리함.

```swift
let response: HomeResponseDTO = try await BaseService.shared.request(
    endPoint: .home(memberID: memberID, grade: grade, classNumber: classNumber)
)

let response: MatchReadyResponseDTO = try await BaseService.shared.request(
    endPoint: .updateReady(matchID: matchID, memberID: memberID),
    body: MatchReadyRequestDTO(isReady: true)
)
```

위 DTO 이름은 사용 예시이며 아직 구현하지 않았음.
`Info.plist`의 `MATCH_ID`·`MEMBER_ID`는 같은 이름의 빌드 설정을 문자열로 참조함.
로컬 `Config.xcconfig`에 시연용 ID를 설정하며, 해당 파일은 Git 제외 대상임.
이번 작업에서는 xcconfig의 Xcode 연결 설정을 변경하지 않음.
실제 호출 전 `BASE_URL` 빌드 설정에 Swagger 서버 주소가 전달되는지 확인 필요함.
