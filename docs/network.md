# 네트워크

프로젝트 작업 원칙과 비밀값 규칙은 [AGENTS.md](../AGENTS.md#보안) 참고.

## 구성

- URLSession·async/await 기반 `BaseService` 사용. `EndPoint`에서 경로·메서드·쿼리·헤더 정의함.
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
