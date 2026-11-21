# SoundTug

- 담당: ser0kim · 상태: 기록 제출·결과 조회 연결 (실서버 게임 실행 미확인)

## 흐름
홈 → 게임방 → 줄다리기 → 권한 확인 → 10초 측정 → 최고 음량 제출 → 서버 결과 → 게임방/홈. 정상 종료만 제출함.

## 주요 파일
| 파일 | 역할 |
| --- | --- |
| `ViewModel/SoundTugViewModel.swift` | 측정·제출·결과 대기·재시도·취소 |
| `Model/SoundTugMatchContext.swift` | 컨피그 경기·멤버 ID 검증, 우리 팀 슬롯 1 |
| `Data/Network/DTO/SoundTug/` | 제출 payload·응답 검증·서버 결과 변환 |

## 상태와 데이터
- `submitVoiceRecord`에 최고 음량을 `maxDecibel`로 전달하고 `voiceResult`로 합계·판정을 조회함.
- 제출 성공은 보존하며 이후 재시도는 조회만 함. 제출 응답 유실 시 확정 결과를 먼저 확인함.
- 결과 미완성(409 GAME_RECORDS_NOT_COMPLETE)이면 1초마다 조회, 30초 후 기록을 보존하고 재시도 제공함.

## 주요 결정
- 사용자 합의: dBFS+120을 0~120으로 제한해 제출·표시함. dB(시연)이며 실제 소음계 SPL 수치가 아님.
- 기존 점수 가산·소음 차단은 제거함. 최고값은 원본 보정 음량, 현재값만 상승 0.12초·하강 0.25초로 표시 보정함.
- 우리 팀 슬롯은 1, 경기·멤버 ID는 Config.xcconfig 사용. 이름은 우리 팀/상대 팀, 승패·합계는 서버 응답 사용함.

## 다른 화면에서 쓸 수 있는 것
- `SoundTugView(onFinish:onNextGame:onGoHome:)`가 보정 최고 음량과 이동 콜백을 제공함.

## 주의·남은 일
- 화면 이탈·백그라운드에서 작업 취소, 활성화 복귀 시 결과 처리를 재개함. 승점은 기존 표시 규칙이며 직접 지급·저장하지 않음.
- 준비·종목 선택 API는 별도 작업. 테스트할 MATCH_ID는 VOICE_TUG·IN_PROGRESS 상태여야 함. 다음 경기에는 새 경기 ID 필요함.
