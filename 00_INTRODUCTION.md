# Introduction

## Lean이란

- Microsoft Research에서 개발되었으나, 현재는 Lean FRO (Focused Research Organization)에서 개발이 진행
- 의존 타입 이론(dependent type theory)에 기반한 상호작용형 정리 증명기
- 범용 프로그래밍 언어로 사용하기에 적합하도록 설계

## 엄격한 순수 함수형 언어(strict pure functional language)

- 엄격성(Strictness): 인자(arguments)는 함수 본문이 실행되기 전에 완전히 계산
- 순수성(Purity): 타입(type)에 명시되지 않은 한, 메모리 위치 수정, 이메일 발송, 파일 삭제와 같은 부수 효과(side effects)를 가질 수 없음을 의미
- 함수형(functional): 함수가 다른 데이터와 마찬가지로 일급 객체(first-class values)이며, 실행 모델이 수학적 식의 평가에서 영감을 얻었음
- 의존 타입(Dependent types): 타입을 언어의 일급 구성 요소로 만들어, 타입이 프로그램을 포함하거나 프로그램이 타입을 계산할 수 있도록 함

- Strict Evaluation
  - (eager evaluation)
  - 표현식이 변수에 결합되자마자 평가
  - 반대는 Lazy evalution (Haskell)

## FP 튜토리얼 대상 독자

- 일반 프로그래머: 함수형 언어 경험은 없어도 되지만, 기본적인 프로그래밍 개념(루프, 함수 등)은 알고 있어야 함
- 수학자: Python 등에 익숙한 수학자들이 Lean을 활용해 고도화된 증명 자동화 도구를 만들 수 있도록 함

## 튜토리얼 진행순서

- 선형적 독해: 개념이 누적되므로 **처음부터 순서대로 읽는 것**을 권장합니다.
- 실습 중심: **연습 문제**를 풀고 직접 코드를 탐구하며 배운 내용을 체화해야 합니다.

## CLI

- elan: rustup이나 ghcup과 유사하게, Lean 컴파일러 툴체인(버전)을 관리
  - `elan toolchain install stable`
  - `elan default stable`
  - `elan override set {version}`
  - `elan show`
  - `elan update`
- lake: cargo, make 또는 Gradle과 유사하게, Lean 패키지와 그 의존성(dependencies)을 빌드
  - `lake new {project}`
  - `lake build`
  - lakefile.toml: 프로젝트의 이름, 버전, 의존성 등을 정의하는 설정 파일
  - lean-toolchain: 이 프로젝트가 어떤 Lean 버전을 사용할지 명시
  - lake-manifest.json: 설치된 의존성 라이브러리들의 정확한 버전(해시값)을 기록하는 파일
  - Main.lean: 실행 파일의 진입점(Entry point)이 되는 파일
- lean
  - 개별 Lean 파일의 타입을 검사하고 컴파일하며, 현재 작성 중인 파일에 대한 정보를 도구에 제공
  - 보통 lean은 사용자가 직접 실행하기보다는 다른 도구들에 의해 호출

## VSCode Extension

[Lean 4](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4)

## #eval

별도의 repl 없이 editor 안에서 결과값 표현

```lean
def add1 (n : Nat) : Nat := n + 1
#eval add1 7 -- 8
```

## Unicode

Lean은 수학적 가독성을 높이기 위해 유니코드를 적극적으로 사용

입력 방식: 백슬래시(\) 기법
대부분의 특수 문자는 LaTeX와 유사한 방식으로 입력할 수 있습니다.

- 그리스 문자:
  - \alpha $\to$ $\alpha$,
  - \beta $\to$ $\beta$
- 화살표: \to 또는 \r $\to$ $\to$
- 집합 기호 등:
  - \bu $\to$ $\bullet$,
  - \N $\to$ $\mathbb{N}$ (자연수 집합)

```lean
-- α : this is alpha (\alpha)
-- β : this is beta (\beta)
-- → : this is arrow (\to or \r)
-- • : this is bullet (\bu)
-- ℕ : this is natural numbers (\N)
```
