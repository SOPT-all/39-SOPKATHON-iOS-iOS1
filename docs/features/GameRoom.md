# 게임방

- 담당: Jeonsieon
- 상태: 진행 중

## 흐름
홈 "게임 시작하기" → "준비 완료"(취소 가능) → 우리 팀 빨강·상대 팀 파랑 ready → 종목 탭 → 당선 배지 → 3·2·1 → `onSelectGame`으로 루트가 게임 화면 push

## 주요 파일
| 파일 | 역할 |
| --- | --- |
| `Presentation/GameRoom/View/GameRoomView.swift` | 화면 조립, 단계별 레이아웃·버튼, 카운트다운 후 `onSelectGame` 호출 |
| `Presentation/GameRoom/View/MatchBanner.swift` | 양 팀 준비 상태에 따라 색·ready 표시가 바뀌는 VS 배너 |
| `Presentation/GameRoom/View/GameCard.swift` | 종목 카드(`locked`·`available`·`selected`·`unselected`) |
| `Presentation/GameRoom/View/GameCountdownOverlay.swift` | 3·2·1 Lottie(`Resource/Lottie/countdown-3-2-1.json`) 오버레이 |
| `Presentation/GameRoom/ViewModel/GameRoomViewModel.swift` | 준비 상태와 `Phase`(대기→선택→확정→카운트다운→시작) |

## 상태와 데이터
- 매칭 정보·상대 팀 준비·종목 확정은 목데이터임. 준비 1.5초 뒤 상대 팀 준비, 다시 1.5초 뒤 종목 선택으로 넘어감.

## 주요 결정
- Figma 최종 디자인 홈-3~11, 화면설계서 S02-A~I 기준. 이름(민서·지우 / 륜영·수현)과 ready는 손글씨 이미지.
- 종목 카드는 선택된 종목만 컬러 이미지, 나머지는 회색. 확정 후 1초 동안 당선 배지를 보여주고 카운트다운함.
- Lottie 재생 완료 시 게임 시작(완료 알림 누락 대비 3.5초 타임아웃). 가운데 영역만 스크롤함.

## 다른 화면에서 쓸 수 있는 것
- `Game` enum: 게임 화면 이동 시 종목 전달에 사용 가능.

## 주의·남은 일
- 폴링(상대 팀 준비), 종목 선착순 서버 확정은 미구현. 소리 줄다리기 설명은 Figma 문구 확정 필요.
