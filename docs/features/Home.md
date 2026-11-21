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

## 상태와 데이터
- 내 이름·학교·멤버 목록은 목데이터임. 활동 상태는 명세상 UI 전용이라 서버 없이 표시함.

## 주요 결정
- Figma 최종 디자인 홈(`2098:7970`) 기준. 상단 여백은 안전 영역 기준으로 적용함.
- 우리 팀 이름(민서·지우)과 반 제목은 서버 고정값이라 손글씨 이미지로 표시하고, 서버 이름은 텍스트에만 반영함.
- 배경 트랙은 Figma 375pt 좌표로 배치하고 화면 폭에 맞춰 확대함(넓은 기기에서 트랙 안쪽 잔디 노출 방지).

## 다른 화면에서 쓸 수 있는 것
- 공통 컴포넌트는 `Presentation/Common/Component` 참고(`PrimaryButton`, `SchoolTag`, `ProfileAvatar`, `TopNavi`).

## 주의·남은 일
- 온보딩 정보·멤버 API 연동 전임.
