# 팀 상세 컨벤션

프로젝트 작업 원칙은 [AGENTS.md](../AGENTS.md) 참고. 작업과 관련된 항목에만 적용함.

## 폴더 구조

```text
39-SOPKATON-iOS/39-SOPKATON-iOS/
├── Application/                 # 앱 진입점
├── Data/
│   └── Network/
│       ├── Base/                # 공통 요청·응답·에러·로그
│       └── DTO/                 # API 요청·응답 DTO
├── Presentation/
│   ├── Common/
│   │   ├── Component/           # 여러 화면에서 사용하는 UI
│   │   ├── Extension/           # 공통 확장
│   │   └── Resource/            # Assets·폰트
│   └── Home/
│       ├── Model/               # 화면에서 사용하는 모델
│       ├── View/                # 화면 UI
│       └── ViewModel/           # 화면 상태·이벤트 처리
└── Info.plist
```

- 새 화면은 기존 화면별 구조를 참고해 추가함.
- 화면 전용 컴포넌트는 해당 화면 내부에 두고, 실제로 공유하는 경우 Common으로 이동함.
- 빈 폴더는 `.gitkeep`으로 유지함. 실제 파일 추가 후 불필요한 `.gitkeep` 제거 가능.
- 동기화 폴더의 `.gitkeep`은 앱 리소스 복사 대상에서 제외해야 함. 여러 파일이 같은 이름으로 복사되면 빌드 오류가 발생함.

## 폰트와 리소스

- Pretendard는 `Presentation/Common/Extension/Font+.swift`를 통해 사용함.

```swift
Text("제목")
    .font(AppFont.title)

Text("내용")
    .font(.pretendard(.semiBold, size: 18))
```

- `AppFont.title`, `body`, `caption`은 임시 스타일임. 디자인 확정 후 이름·굵기·크기를 수정하고 화면에서 재사용함.
- 현재 폰트 확장은 고정 크기 방식임.
- 폰트 추가 시 실제 PostScript 이름과 `Info.plist`의 `UIAppFonts` 등록 확인 필요.
- 공통 색상·이미지는 기존 Assets를 확인한 뒤 추가함. 같은 리소스의 중복 생성 지양.
- `Info.plist`는 빌드 설정에서 참조하며 Copy Bundle Resources에 포함하지 않음.

## 코드 예시

코드 스타일 규칙은 [AGENTS.md의 코드 컨벤션](../AGENTS.md#코드-컨벤션)에 정의함.
아래는 설명용 예시이며 별도의 구현 요구사항이 아님.

### 네이밍과 선언

```swift
let maximumCount = 10
var users: [User] = []
var selectedUser: User?
var hasNextPage = true

func fetchUser(id: Int) { }

// 부모 화면: HomeView / 자식 UI: HomeHeader, HomeCard
```

### 레이아웃과 공백

```swift
final class HomeViewModel {

    private(set) var isLoading = false

    func fetchItems(
        categoryID: Int,
        page: Int
    ) async {
        // TODO: 목록 조회 연결 필요.
    }

}
```

## 이미지 에셋 컨벤션

- Assets 안에 화면별 폴더를 만들어 추가함. 예: `Home/home_logo`.
- 에셋명은 Figma와 통일함. 불명확한 경우 리드에게 확인함.
- 벡터 아이콘은 SVG 추출 우선. 원본 색상·선·모양이 정상 표시되는지 확인함.
- 벡터 에셋의 Scales는 Single Scale 설정 확인 필요.
- 사진이나 SVG로 정상 표현되지 않는 이미지는 PNG 사용함.
- PNG는 필요에 따라 1x·2x·3x로 등록하고 실제 화면의 선명도 확인함.

## Git 컨벤션

커밋 형식은 `[태그] #이슈번호 - 작업내용`임. 변경은 작업별로 나눠 커밋함.
이슈번호는 현재 작업에 해당하는 번호 사용. 미확정 시 임의 번호를 넣지 않음.
태그는 변경의 주목적 기준으로 선택함. API 연동은 `network`, UI 구현은 `style`,
에셋·라이브러리 추가는 `add`, 프로젝트 설정 변경은 `setting` 우선 사용함.
새 사용자 기능 자체가 주목적이면 `feat` 사용하고, 성격이 다른 작업은 커밋을 나눔.

| 태그 | 용도 |
| --- | --- |
| feat | 새로운 기능 구현 |
| style | UI 구현 |
| fix | 버그·오류 해결 |
| docs | README·템플릿 등 문서 수정 |
| setting | 프로젝트 설정 변경 |
| add | 에셋·라이브러리 추가 |
| refactor | 기존 코드 구조 개선·수정 |
| chore | 기타 경미한 수정 |
| network | 네트워크 작업 |
| merge | 브랜치 병합 |

```text
[setting] #1 - 프로젝트 폴더 구조 정리
[network] #1 - URLSession 네트워크 베이스 구성
```

- 새 작업 브랜치는 최신 main을 기준으로 생성함. 현재 작업 브랜치에 이어서 진행하는 요청이면 기존 브랜치 사용.
- 브랜치명은 `태그/#이슈번호` 형식 사용.

```text
feat/#1
add/#3
refactor/#53
```

- PR 제목의 별도 형식은 팀 합의에 따름.
- PR은 `.github/PULL_REQUEST_TEMPLATE.md`를 사용하고 변경 내용·검증 결과를 작성함.
- 커밋·푸시·PR 생성·머지·브랜치 삭제는 현재 요청에서 허용한 범위까지만 진행함.
- 다른 사람의 변경을 임의로 되돌리거나 커밋 이력을 재작성하지 않음.

## PR·머지 체크리스트

- [ ] 빌드 성공 확인
- [ ] 변경 화면·핵심 기능 동작 확인
- [ ] 불필요한 print·임시 코드 제거
- [ ] Preview·미사용 목업 데이터 제거
- [ ] 미사용 import·주석·MARK 제거
- [ ] 네이밍·접근 제어 확인
- [ ] PR 생성 시와 머지 전에 카카오톡으로 팀에 공유
- [ ] 머지 전 최신 원격 대상 브랜치(예: origin/main)를 작업 브랜치에 반영하고 충돌·빌드 확인
- [ ] 리드 approve 확인 후 머지
- [ ] 머지 완료 후 작업 브랜치 삭제

카카오톡 공유는 팀원의 협업 절차임. AI의 메시지 전송은 현재 요청에서 명시적으로 허용된 경우에만 진행함.
