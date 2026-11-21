# 홈

- 담당: Jeonsieon
- 상태: 진행 중

## 흐름
앱 시작(`RootView`) → 내 프로필·학교·반 멤버 확인 → "게임 시작하기" → `onStartGame`으로 루트가 매칭 대기 push
우측 상단 랭킹 아이콘 → `onShowRanking`으로 루트가 랭킹 화면 push

## 주요 파일
| 파일 | 역할 |
| --- | --- |
| `Presentation/Home/View/HomeView.swift` | 화면 조립, Figma 좌표 배경(`HomeBackground`) |
| `Presentation/Home/View/MemberCard.swift` | 활성·오프라인 멤버 카드 |
| `Presentation/Home/ViewModel/HomeViewModel.swift` | 홈 조회(`GET /api/v1/home`), 로딩·실패 상태 |

## 상태와 데이터
- 내 이름·학교·멤버는 홈 API 응답. 요청 값은 `Config.xcconfig`의 `MEMBER_ID`·`GRADE`·`CLASS_NUMBER`.
- 활동 상태는 명세에 없어 나 + 첫 번째 팀원만 활동 중으로 표시함. 실패 시 알림에서 다시 시도함.

## 주요 결정
- Figma 최종 디자인 홈(`2098:7970`) 기준. 상단 여백은 안전 영역 기준으로 적용함.
- 이름(민서·지우)과 반 제목(1학년1반선수)은 시연 고정값이라 손글씨 이미지, 그 외 이름은 텍스트로 표시함.
- 배경 트랙은 Figma 375pt 좌표로 배치하고 화면 폭에 맞춰 확대함(넓은 기기에서 트랙 안쪽 잔디 노출 방지).

## 다른 화면에서 쓸 수 있는 것
- 공통 컴포넌트는 `Presentation/Common/Component` 참고(`PrimaryButton`, `SchoolTag`, `ProfileAvatar`, `TopNavi`).

## 주의·남은 일
- 온보딩 연동 전이라 요청 값은 시연 설정을 읽음. 반 제목 이미지는 다른 학급이면 맞지 않음.
