# 말 달리기(경마) 게임

- 담당: SeongHwan
- 상태: 진행 중

## 흐름

(진입 경로 미정) → 회색 "준비..." 화면에서 3초 카운트다운 → 빨간 "연타!!!" 화면으로 바뀌며 타이머 시작 →
아래 버튼 59회 탭으로 배경 트랙이 끝까지 흐름 → 이어서 13회 탭하면 달리는 사람이 오른쪽 화면 밖으로 나가며 완주(총 72회) → 탭을 무시하고 `onFinish`로 기록(초) 전달. 이동할 결과 화면은 미정임.

## 주요 파일

| 파일 | 역할 |
| --- | --- |
| `Presentation/HorseRace/View/HorseRaceView.swift` | 화면 조립, 카운트다운 시작, 완주 시 `onFinish` 호출 |
| `Presentation/HorseRace/ViewModel/HorseRaceViewModel.swift` | 단계 전환, 탭 수·트랙/달리는 사람 진행률·버튼 문구 계산 |
| `Presentation/HorseRace/Model/HorseRacePhase.swift` | 준비·진행(시작 시각)·완주(기록) 단계 |
| `Presentation/HorseRace/View/HorseRaceTrack.swift` | 트랙 배경(레인·곡선·번호)과 진행률만큼 왼쪽으로 흐르는 연출 |
| `Assets.xcassets/HorseRace/` | Figma에서 추출한 안내 문구·달리는 사람·그림자 SVG |

## 상태와 데이터

- `phase`, `tapCount`만 저장하고 진행률·버튼 문구는 계산 속성임.
- 서버 API 없음. 로컬 상태로만 동작함.

## 주요 결정

- Figma UI(2098:7627 준비, 2098:7546 진행) 기준. 화면에 기록·남은 거리는 표시하지 않고 기록은 `onFinish`로만 전달함.
- 탭은 아래 버튼만 셈. 준비·완주 중 탭은 ViewModel이 무시하고 버튼은 디자인대로 항상 검정으로 둠.
- 트랙은 Figma 프레임(2446 x 812)을 화면 높이에 맞춰 확대하고, 진행 화면은 레인 번호가 가려지는 위치(301)에서 출발함.

## 다른 화면에서 쓸 수 있는 것

- 없음

## 주의·남은 일

- 탭 수는 탭당 약 30pt 기준임. 트랙 59회(`trackTapCount`, 흐르는 거리 약 1,770pt) + 달리는 사람 13회(`runnerExitTapCount`, 화면 폭 약 375pt). 트랙 길이를 바꾸면 함께 조정 필요.
- 카운트다운 3초는 임시임. 서버 시작 신호를 쓸지 미정이라 TODO로 남김(`countdown`).
- 완주 상태 디자인이 없어 진행 화면에 버튼 문구만 "완주!"로 바꿈.
- 결과 화면 연결, 기록 서버 전송, 다시 하기는 미구현임.
