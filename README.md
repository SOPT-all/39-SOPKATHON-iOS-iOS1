<div align="leading">

# 서비스 이름

<!-- 서비스명 확정 후 위 제목을 변경하고, 필요하면 여기에 로고 또는 배너를 추가해 주세요. -->

### 우리 반에서 시작되는, 새로운 연결

초·중·고등학생이 함께하는 게임으로 반 사이의 연결을 이어가는 iOS 앱

**39기 PLAY SOPT · 솝커톤 iOS 1조**
</div>

<br>

## 01 · 서비스 소개

**화합을 주제로, 함께 참여하고 반응하며 반별 교류를 만들어 갑니다.**

사회성 결여와 끊겨 있는 연결성에 주목했습니다.
문답 형식의 영상 릴레이와 참여 방식이 다른 여러 게임을 통해,
서로를 알아가고 함께할 기회를 만드는 것을 목표로 합니다.

| 대상 | 핵심 경험 | 참여 방식 |
| :---: | :---: | :---: |
| 초·중·고등학생 | 게임을 통한 반별 교류 | 반 전체 등록 정원 + 게임별 참여 정원 |

> 현재 기획 기준입니다. 추가 게임의 종류·규칙과 정원 수치는 미정입니다.

<br>

## 02 · iOS Team

<!-- 팀원별 이름과 담당 화면·기능을 채워 주세요. 역할은 확정 후 작성합니다. -->

| 팀원 | GitHub | 담당 화면 | 담당 기능 |
| :---: | :---: | --- | --- |
| 이름 입력 | [@Eda3399](https://github.com/Eda3399) | 작성 예정 | 작성 예정 |
| 이름 입력 | [@limtjdghks](https://github.com/limtjdghks) | 작성 예정 | 작성 예정 |
| 김세령 | [@ser0kim](https://github.com/ser0kim) | 작성 예정 | 작성 예정 |
| 이름 입력 | [@siiooin](https://github.com/siiooin) | 작성 예정 | 작성 예정 |

<br>

## 03 · 주요 기능 & 기술 스택

### 주요 기능

<!-- 구현 후 각 기능의 상태와 설명을 실제 동작에 맞춰 갱신해 주세요. -->

| 기능 | 내용 | 상태 |
| --- | --- | :---: |
| 온보딩 | 학교·학년·반·번호·이름 입력 및 서버 등록 | 기획 |
| 게임 참여 | 여러 방식의 게임 제공, 반 전체·게임별 정원 적용 | 기획 |
| 문답 영상 릴레이 | 질문을 매개로 영상을 공유하며 반별 교류 | 기획 |
| 반응 & 순위 | 기존 영상 릴레이에서 일정 기간 반응을 모아 순위 산정 | 기획 |

추가 게임의 구체적인 내용과 결과 집계 방식은 확정 후 작성합니다.

### 기술 스택

| 영역 | 기술 | 적용 범위 |
| --- | --- | --- |
| Language | Swift 5 | 프로젝트 언어 모드 |
| UI | SwiftUI | 화면 구성 기반 |
| State | Observation · MVVM | `@Observable` ViewModel, `@State` 소유 방식이 팀 설계 기준 |
| Network | URLSession · async/await | `BaseService`·`EndPoint` 공통 통신 기반 |
| Image | Kingfisher 8.x | SPM 의존성 추가 완료, 이미지 캐싱에 사용 예정 |
| Camera | UIImagePickerController | 기존 영상 릴레이 촬영에 사용 예정 |
| Video | AVKit · VideoPlayer | 기존 영상 릴레이 재생에 사용 예정 |
| Resource | Pretendard · Assets | 공통 폰트·이미지 리소스 |

상세 선택 이유와 추천·미정 항목은 [기술 스택 문서](docs/tech-stack.md)를 참고합니다.

<br>

## 04 · Convention & Branch Strategy

### 코드 컨벤션

| 구분 | 규칙 |
| --- | --- |
| 네이밍 | 타입은 `UpperCamelCase`, 함수·변수는 `lowerCamelCase` |
| 식별자 | `userID`, `profileURL`처럼 ID·URL 대문자 유지 |
| 화면 | 부모 화면에만 `View` 접미사 사용 |
| 구조 | `Presentation/<화면>/Model·View·ViewModel` |
| 역할 | View는 UI·이벤트 전달, ViewModel은 상태·처리 담당 |
| 스타일 | 공백 4칸, 줄 길이 90자 권장·최대 99자 |
| 리소스 | 공통 폰트·Assets 우선 재사용 |

[팀 공용 가이드](AGENTS.md) · [Swift 상세 스타일](docs/swift-style.md) · [폴더·리소스 규칙](docs/structure-assets.md)

### 브랜치 전략

**최신 `main` → 이슈별 작업 브랜치 → PR → 리드 승인 → `main` 병합**

- 작업 브랜치는 `태그/#이슈번호` 형식으로 생성합니다.
- 기능 단위로 커밋하고, 팀 PR 템플릿으로 변경 내용과 검증 결과를 공유합니다.
- 병합 전 최신 `main`을 반영하고, 병합이 끝난 작업 브랜치는 삭제합니다.
- PR 생성 시와 병합 전에 팀 카카오톡으로 공유합니다.

```text
브랜치    docs/#17
커밋      [docs] #17 - README 템플릿 작성
PR 제목   [docs/#17] README 템플릿 작성
```

<!-- PR 제목은 이번 작업의 예시이며, 팀의 고정 규칙을 뜻하지 않습니다. -->

자세한 태그와 협업 절차는 [Git 컨벤션](docs/git.md)을 참고합니다.

<br>

## 05 · Before — 해커톤 시작 전, 우리

<!-- 각 셀의 '사진 추가 예정'을 GitHub에 업로드한 이미지로 교체해 주세요.
예시: <img src="업로드한 이미지 URL" width="180" alt="팀원 이름 Before 사진" />
실제 사진이 준비되기 전에는 이미지 태그를 활성화하지 않습니다.
<img width="500" alt="스크린샷 2026-11-22 오전 1 11 39" src="https://github.com/user-attachments/assets/c8c3b1ab-e535-44cc-bf29-2772277e64f2" />


