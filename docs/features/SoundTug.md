# SoundTug

- 담당: ser0kim
- 상태: 진행 중 (종료 팝업·이동 연결, 팀 결과 API 미연동)

## 흐름
화면 진입 → 측정 시작 → 권한 확인 → 10초 측정 → 경기 종료 팝업 → 다음 게임(게임방) 또는 홈.
시작 실패는 throw, 측정 중 인터럽트·장치 구성 변경·미디어 리셋은 failure로 전달하고 다음 측정에 새 엔진 사용함.
## 주요 파일
| 파일 | 역할 |
| --- | --- |
| `Presentation/SoundTug/Audio/SoundLevelMeter.swift` | 마이크 입력 수명 관리 |
| `Presentation/SoundTug/View/SoundTugGameOver.swift` | 기존 공통 결과 팝업 재사용 |
| `Presentation/SoundTug/View/SoundTugView.swift` | Figma 준비·측정 화면, SVG 글자 및 음량 반응 애니메이션 |
| `Presentation/SoundTug/ViewModel/SoundTugViewModel.swift` | 시간·현재 및 최고 점수 관리 |
## 상태와 데이터
- 38점에서 소음 차단 해제, 35점 이하에서 차단함. 표시값만 상승 0.12초·하강 0.25초 보정하며 최고 기록은 차단 후 원본 사용함.

## 주요 결정
- RMS 기반 환산값 40점까지 유지, 40~80점에서 제곱 곡선으로 최대 20점 가산함. 0~100 제한, 소수점 한 자리 표시함.
- 10초는 마이크 준비 후 시작함. 반 비교·dB 대신 내 현재·이번 측정 최고 점수만 표시함.
- 회색 준비 화면에서 버튼을 누르면 노란 측정 화면으로 전환함. 현재 음량에 비례해 줄 무늬·손·줄 표식이 왼쪽으로 당겨지고 작아지면 돌아옴.
- 정상 종료에만 덮개·결과 팝업을 표시함. 결과가 없으면 개인 기록만 표시하고 팀 합계·승패·승점을 생성하지 않음.

## 다른 화면에서 쓸 수 있는 것
- `SoundTugView(onFinish:onNextGame:onGoHome:result:)`: 개인 기록·이동 콜백과 선택적 팀 결과를 받음. Record.volumeScore는 점 단위임.

## 주의·남은 일
- RootView → 홈 → 게임방 → 종목 선택으로 진입함. 화면 이탈·백그라운드에서 취소하며 서버에 기록 제출하지 않음.
- 결과 API 미연동: 기본값은 팀 결과 확인 불가. 전달된 결과만 승/패 배너, 무/무효 문구와 합계를 표시함. 지급 저장은 하지 않음.
