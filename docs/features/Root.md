# Root
- 담당: ser0kim
- 상태: 기존 뷰 연결 완료, 미구현 UI 연결 대기

## 흐름
앱 → RootView → 홈 → 게임방 → 준비 완료 → 종목 선택 → 해당 게임.
정상 종료 기록은 루트에 전달함. 결과 UI 추가 전에는 기존 게임 완료 화면을 유지함.

## 주요 파일
| 파일 | 역할 |
| --- | --- |
| `Presentation/Root/View/RootView.swift` | 유일한 NavigationStack 및 목적지 조립 |
| `Presentation/Root/ViewModel/RootViewModel.swift` | 경로·완료 기록·이동 처리 |
| `Presentation/Root/Model/GameResult.swift` | 이어달리기 초 / 줄다리기 개인 점수 구분 |

## 상태와 데이터
- `path`는 시스템 뒤로가기와 양방향 동기화함. 화면을 떠나면 완료 기록을 지움.
- 게임방 데이터는 기존 목데이터 유지. 줄다리기 실패·취소에는 완료 이벤트를 전달하지 않음.

## 결정사항
- 화면별 스택 대신 루트 한 곳에서 관리하고, 화면은 콜백만 전달해 재사용함.
- 다음 게임은 반대 종목으로 현재 경로를 교체함. 이전 게임이 쌓이지 않음.
- 결과 UI는 추후 게임 위에 표시하고 `startNextGame()` / `popToRoot()`를 연결함.

## 다른 화면에서 쓸 수 있는 것
- 뷰 추가 순서: `AppRoute` case → `RootView.destination` 분기 → 출발 화면 콜백 연결.
- 한 단계 복귀는 `pop()`, 홈 복귀는 `popToRoot()`. 스플래시·대기·랭킹은 뷰 확정 후 추가함.

## 주의·남은 일
- 홈·게임방 기존 문서의 스택 소유·게임 미연결 설명은 현재 코드와 다름. 이 문서 기준으로 연결함.
