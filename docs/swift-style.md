# Swift 상세 스타일

[AGENTS.md의 Swift 핵심 규칙](../AGENTS.md#swift-핵심-규칙)과 함께 적용함. 적용 범위도 같음.
코드 예시는 설명용이며 별도의 구현 요구사항이 아님.

## 네이밍과 선언

- 타입·클래스·구조체·enum·프로토콜은 UpperCamelCase 사용. extension도 대상 타입명 유지함.
- 함수·변수·상수·enum case는 lowerCamelCase 사용.
- 역할과 책임이 드러나는 이름 사용. 불필요한 약어 지양함.
- Bool은 `is`, `has`, `can`, `should` 등으로 상태를 표현함.
- 함수는 동사로 시작하고 호출부에서 자연스럽게 읽히도록 작성함.
- 변경하지 않는 값은 `let` 우선 사용. 변경이 필요한 경우에만 `var` 사용함.
- 타입이 명확하면 타입 추론 사용. 빈 배열·초기값 없는 옵셔널은 타입 명시함.

```swift
let maximumCount = 10
var users: [User] = []
var selectedUser: User?
var hasNextPage = true

func fetchUser(id: Int) { }

// 부모 화면: HomeView / 자식 UI: HomeHeader, HomeCard
```

## 접근 제어와 프로토콜

- 저장 속성·override 메서드 등 extension에 작성할 수 없는 코드는 본체에 둠.
- 컴파일러가 합성하는 프로토콜 구현은 합성 가능한 위치에 선언함.

## 레이아웃과 공백

- 들여쓰기는 공백 4칸 사용함.
- 줄 길이는 90자 이내 권장, 최대 99자로 제한함.
- 콜론 오른쪽, 쉼표 뒤, 연산자 양옆에 공백 사용함.
- 연산자 오버로딩 함수는 연산자와 여는 괄호 사이에 공백 한 칸 사용함.
- 긴 함수 정의·호출은 파라미터 단위로 줄바꿈함.
- 클로저 파라미터가 2개 이상이면 길이와 관계없이 파라미터별 줄바꿈함.
- 긴 `if let`·`guard let` 조건은 줄바꿈하고 들여씀. `else`는 `guard`와 같은 깊이로 정렬함.
- 함수 사이에는 빈 줄 하나 사용함.
- 타입·extension 스코프의 맨 위와 아래에는 빈 줄 하나 사용함.
- 함수 내부 시작·끝에는 불필요한 빈 줄을 넣지 않음.
- MARK 위아래에는 빈 줄 사용함. 불필요한 MARK는 제거함.
- `@objc`는 함수 선언과 줄을 나눠 작성함.
- 빈 줄의 공백 제거. 파일 끝에는 개행을 남김.

```swift
@Observable
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

## Import

- 내장 프레임워크를 먼저 import하고, 빈 줄 뒤에 서드파티 라이브러리 import함.
- 각 그룹 안에서는 알파벳순으로 정렬함. 사용하지 않는 import 제거함.

## 옵셔널과 클로저

- 값이 없으면 종료할 때는 `guard let`, 값이 있을 때만 실행할 때는 `if let` 사용함.
- 짧고 명확한 클로저는 `$0` 사용 가능. 복잡한 조건은 인자 이름 명시함.
- `[weak self]`는 순환 참조 가능성이 있는 경우에만 사용함.
- 이름 구분·클로저 문법상 필요한 경우 외에는 불필요한 `self` 지양함.

## SwiftUI

- `body`에서 화면 전체 구조가 보이도록 작성함.
- 독립적인 역할의 UI는 별도 View 타입으로 분리함.
- 간단한 화면 전용 UI는 계산 속성으로 분리 가능함.
- 내부에서만 사용하는 상태에는 `private` 사용함.
- 의미가 불분명한 숫자·문자열의 반복 사용 지양함. 기존 공통 색상·폰트·간격 정의 우선 사용함.
