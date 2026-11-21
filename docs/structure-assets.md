# 폴더 구조·Figma·리소스

프로젝트 작업 원칙은 [AGENTS.md](../AGENTS.md) 참고. 작업과 관련된 항목에만 적용함.

## 폴더 구조

```text
39-SOPKATHON-iOS/39-SOPKATHON-iOS/
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

- 새 화면은 `Presentation/<화면>/Model·View·ViewModel` 구조로 추가함.
- 화면 전용 컴포넌트는 해당 화면 내부에 두고, 실제로 공유하는 경우에만 `Common`으로 이동함.
- 빈 폴더는 `.gitkeep`으로 유지함. 실제 파일 추가 후 불필요한 `.gitkeep` 제거 가능.
- 동기화 폴더의 `.gitkeep`은 앱 리소스 복사 대상에서 제외해야 함. 여러 파일이 같은 이름으로 복사되면 빌드 오류가 발생함.

## Figma

- Figma 연결·기준 지정 시 해당 디자인 지침·설계서·컴포넌트·토큰을 우선 적용함.
- 색상·폰트·여백·정렬·안전 영역·선택 상태·스크롤·탭바·화면 전환을 확인하고 임의의 유사 디자인으로 대체하지 않음.
- 요구사항·기존 코드와 충돌하거나 디자인이 불명확하면 질문함. 구현 화면과 비교하지 못했으면 미확인으로 보고함.

## 폰트와 리소스

- Pretendard는 `Presentation/Common/Extension/Font+.swift`를 통해 사용함.

```swift
Text("제목")
    .appFont(.headerMBold)

Text("내용")
    .appFont(.bodyLRegular)
```

- `AppFont`는 Figma 디자인시스템 Typography 16종이며 이름은 `역할/크기/굵기`를 따름. 예: `Body/L/Regular` → `.bodyLRegular`.
- `.appFont(_:)`는 폰트와 Figma 행간을 함께 적용함. 행간이 필요 없으면 `.font(AppFont.bodyLRegular.font)` 사용함.
- 디자인시스템에 없는 크기만 `.pretendard(_:size:)`로 직접 지정함.
- 현재 폰트 확장은 고정 크기 방식임.
- 공통 색상은 Assets의 `Color` 폴더에 Figma 이름(`grey-1` ~ `grey-10`)으로 둠. 사용 예: `.foregroundStyle(.grey10)`.
- 폰트 추가 시 실제 PostScript 이름과 `Info.plist`의 `UIAppFonts` 등록 확인 필요.
- 공통 색상·이미지는 기존 Assets를 확인한 뒤 추가함. 같은 리소스의 중복 생성 지양.
- `Info.plist`는 빌드 설정에서 참조하며 Copy Bundle Resources에 포함하지 않음.

## 이미지 에셋 컨벤션

- Assets 안에 화면별 폴더를 만들어 추가함. 예: `Home/home_logo`.
- 에셋명은 Figma와 통일함. 불명확한 경우 리드에게 확인함.
- 벡터 아이콘은 SVG 추출 우선. 원본 색상·선·모양이 정상 표시되는지 확인함.
- 벡터 에셋의 Scales는 Single Scale 설정 확인 필요.
- 사진이나 SVG로 정상 표현되지 않는 이미지는 PNG 사용함.
- PNG는 필요에 따라 1x·2x·3x로 등록하고 실제 화면의 선명도 확인함.
