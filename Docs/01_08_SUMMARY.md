## 1.8 Summary

Lean은 “순수 함수형 + 강력한 타입 시스템 + 종료 보장”을 기반으로 하는 언어

### 1.8.1 Evaluating Expressions 표현식 평가

- 표현식은 수학적 규칙으로 평가됨
- `if`, `match`는 조건이 먼저 평가됨
- 변수는 immutable (값이 변하지 않음)

### 1.8.2 Functions 함수

- 함수는 first-class
- 모든 함수는 단일 인자 (커링 사용)
- 함수 생성 방법:
  - `fun`
  - `·` shorthand
  - `def` / `let`  

### 1.8.3 Types 타입

- 모든 표현식은 타입을 가짐
  - 타입은 일부 테스트를 컴파일러가 수행하게 대체함
- Lean 타입 = 프로그램 + 수학
  - 프로그래밍과 정리 증명을 통일
- 같은 리터럴도 여러 타입 가능 (3 : Nat, 3 : Int)
- 타입 추론은 제한적 → 명시 권장
- 다형성: 타입도 인자로 전달

### 1.8.4 Structures and Inductive Types 구조체와 귀납 데이터타입

- structure = product type
- inductive = sum type
- 생성자는 데이터만 담음 (초기화X)
- 패턴 매칭으로 분해 가능

### 1.8.5 Recursion 재귀

- 반드시 종료해야 함
- 방법:
  - 구조적으로 감소 (Well-founded relation)
  - 또는 종료성 증명 필요 (코더가 수동 증명)
- 무한 재귀 구조는 금지된다.