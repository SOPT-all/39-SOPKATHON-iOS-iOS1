# 말 달리기(경마) 게임

- 담당: SeongHwan
- 상태: 진행 중

## 흐름
게임방에서 종목 선택(`RootView`) → "준비..." 3초 카운트다운 → "연타!!!"에서 타이머 시작 → 72회 탭으로 완주 →
"경기 종료!" 덮개 → 2초 간격으로 경기 완료 확인 → 완료되면 승패 배너·결과 카드 팝업 →
"다음 게임 이어가기"는 게임방(종목 선택)으로, "홈 화면으로 이동"은 홈으로 돌아감(`RootView`의 `pop()`·`popToRoot()`).

## 주요 파일
| 파일 | 역할 |
| --- | --- |
| `View/HorseRaceTrack.swift` | Figma 트랙 좌표(2446 x 812)로 그린 배경과 흐르는 연출 |
| `View/HorseRaceGameOver.swift` | 완주 후 덮개. 결과 전 "경기 종료!", 결과 후 공통 `GameResultPopup` |
| `ViewModel/HorseRaceViewModel.swift` | 탭 수·단계(`HorseRacePhase`)와 완료 확인(`waitForResult`) |

## 주요 결정
- 결과 팝업은 소리 줄다리기와 디자인이 같아 공통 `GameResultPopup`(배너 `GameResultBanner`)으로 둠.
  게임 이름·학교·기록·점수·승패를 값으로 받고, 에셋은 `Common/img_result_*`임.
- 승패는 화면이 정해 넘김. 경마는 두 팀 평균 기록 비교로 계산함(`HorseRaceResult.isWin`).
- 완료 확인 실패도 미완료처럼 재확인함.
- 배너 도형은 게임방 `img_vs_shape_back`·`img_vs_shape_front`를 재사용하고 색은 template으로 바꿈.
- 공통 `SchoolTag`에 패배 쪽 태그용 `.dimmed` 스타일을 추가함.

## 주의·남은 일
- 탭 수는 탭당 약 30pt 기준(트랙 약 1,770pt ÷ 30, 화면 폭 약 375pt ÷ 30). 트랙 길이를 바꾸면 함께 조정 필요.
- 카운트다운 3초는 임시임. 서버 시작 신호 사용 여부 미정이라 TODO로 남김(`countdown`).
- 완료 확인 API 명세가 없어 `fetchResult`가 임시 값으로 바로 완료 처리함. 학교·로고·상대 기록·점수도 임시 값임.
- 기록 서버 전송은 미구현임. 경마는 `finishGame`을 부르지 않아 `GameResult.horseRace`는 쓰이지 않음.
