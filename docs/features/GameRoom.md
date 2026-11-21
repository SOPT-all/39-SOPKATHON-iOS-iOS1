# 게임방

- 담당: Jeonsieon
- 상태: 진행 중

## 흐름

홈 "게임 시작하기" → VS 배너 확인 → "준비 완료" → 전원 준비 시 종목 선택 가능 → (게임 화면 이동은 미연결)

## 주요 파일

| 파일 | 역할 |
| --- | --- |
| `Presentation/GameRoom/View/GameRoomView.swift` | 화면 조립, 뒤로가기 |
| `Presentation/GameRoom/View/GameCard.swift` | 종목 카드(배경 이미지, 하단 블러, 선택 버튼) |
| `Presentation/GameRoom/View/MatchBanner.swift` | 우리 학교 vs 상대 학교 배너 |
| `Presentation/GameRoom/ViewModel/GameRoomViewModel.swift` | 내 준비 상태, 전원 준비 여부, 선택한 종목 |
| `Presentation/GameRoom/Model/Game.swift` | 종목 enum(제목·설명) |

## 상태와 데이터

- `isMeReady`, `selectedGame`을 저장하고 `isAllReady`는 계산함.
- 매칭 정보·다른 팀원 준비 상태는 목데이터임. 다른 팀원은 모두 준비된 것으로 둠.

## 주요 결정

- Figma `홈` 1번째 프레임(`2098:5942`) 기준.
- 전원 준비 전에는 종목 카드 버튼의 탭만 막고 모양은 Figma 회색 그대로 둠. 안내 문구는 Figma 문구 하나로 고정함.
- 준비 완료 후 버튼은 비활성 상태로 바꿈.

## 다른 화면에서 쓸 수 있는 것

- `Game` enum: 게임 화면 이동 시 종목 전달에 사용 가능.

## 주의·남은 일

- 폴링으로 팀원 준비 상태 동기화, 종목 선착순 확정, 선택 후 게임 화면 이동은 미구현임.
