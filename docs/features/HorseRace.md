# 말 달리기(경마) 게임

- 담당: SeongHwan
- 상태: 진행 중

## 흐름
게임방에서 종목 선택(`RootView`) → "준비..." 3초 카운트다운 → "연타!!!"에서 타이머 시작 → 72회 탭으로 완주(탭마다 Figma "달리기1·2" 자세 교대) →
"경기 종료!" 덮개 → 기록 제출 후 3초 간격으로 경기 상태 조회 → `FINISHED`면 결과 조회 후 승패 배너·결과 카드 팝업 →
"다음 게임 이어가기"는 게임방, "홈 화면으로 이동"은 홈. `TIMEOUT`·`CANCELLED`·`INVALID`이면 알림 후 홈으로 이동함.

## 주요 파일
| 파일 | 역할 |
| --- | --- |
| `View/HorseRaceTrack.swift` | Figma 트랙 좌표(2446 x 812)로 그린 배경과 흐르는 연출 |
| `View/HorseRaceGameOver.swift` | 완주 후 덮개. 결과 전 "경기 종료!", 결과 후 공통 `GameResultPopup` |
| `ViewModel/HorseRaceViewModel.swift` | 탭 수·단계(`HorseRacePhase`)와 기록 제출·결과 확인(`waitForResult`) |
| `Model/HorseRaceMatch.swift` | API에 넘길 matchID·memberID·내 teamSlot. 지금은 xcconfig 시연값(`demo`) |

## 상태와 데이터
- `submitHorseRecord` → `matchStatus` → `matchResult` 순으로 호출하고 결과는 `HorseRaceResult.init?(response:myTeamSlot:)`에서 변환함.

## 주요 결정
- 결과는 `horse-result` 대신 공통 `result`를 씀. 반 이름과 완주 시간 합계가 함께 오기 때문임.
- 응답에 내 팀 표시가 없어 내 `teamSlot`을 인자로 받아 고름. 승패는 서버 `result`를 따르고 무승부는 패배로 표시함.
- 제출·조회 실패는 미완료처럼 다음 간격에 재시도함. 기록 재제출은 서버가 무시해 안전함.

## 주의·남은 일
- 탭 수는 탭당 약 30pt 기준. 트랙 길이를 바꾸면 함께 조정 필요. 카운트다운 3초는 임시(TODO `countdown`).
- matchID·memberID·teamSlot은 온보딩·매칭 연동 전 임시 값임. 게임방이 넘기면 `RootView`에서 교체 필요.
- 점수 필드가 서버에 없어 "-"로 표시함. `teamSlot` 실제 응답 타입(Swagger는 string)은 미확인임.
  403·404·409처럼 다시 해도 실패하는 응답도 재시도를 계속해 "경기 종료!"에 머묾.
