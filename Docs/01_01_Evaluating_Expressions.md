# 1. Getting to Know Lean

오늘날 컴파일러는 일반적으로 텍스트 에디터에 통합되어 있으며, 프로그래밍 환경은 프로그램이 작성되는 동안 실시간으로 피드백을 제공

Lean도 예외는 아닙니다. Lean은 텍스트 에디터와 통신하며 사용자가 타이핑하는 동안 피드백을 제공할 수 있도록 하는 확장된 버전의 **언어 서버 프로토콜(Language Server Protocol, LSP)**을 구현

Python, Haskell, JavaScript와 같이 다양한 언어들은 **REPL(read-eval-print-loop)**을 제공

Lean은 이러한 기능을 에디터와의 상호작용에 통합하여, **텍스트 에디터가 프로그램 텍스트 자체에 통합된 피드백을 표시**하도록 하는 명령들을 제공

## 1.1 표현식의 평가 (Evaluating Expressions)

핵심 개념: **프로그램 = 수학 식**

- **평가(Evaluation)**: 복잡한 식을 더 단순한 값으로 줄여나가는(reduce) 과정
- **불변성(Immutability)**: 한 번 정의된 변수의 값은 절대 바뀌지 않습니다.
- **부수 효과 없음(No Side Effects)**: 식을 계산한다고 해서 갑자기 파일이 삭제되거나 이메일이 보내지지 않습니다. 오직 '값'을 구하는 데만 집중
  - '부수 효과'는 본질적으로 수학 식을 평가하는 모델을 따르지 않는, 프로그램 내에서 일어날 수 있는 일들을 통칭하는 용어
- **참조 투명성(Referential Transparency)**: 결과값이 같은 두 식은 서로 완전히 대체 가능

```lean
#eval 1 + 2 -- 3
#eval 1 + 2 * 5 -- 11
```

산술 연산자의 경우 일반적인 우선순위(precedence)와 결합법칙(associativity)을 따름

**함수 호출 방식** 차이점

- 일반 언어: 함수명(인자1, 인자2) — 괄호와 쉼표를 사용
- Lean: 함수명 인자1 인자2 — 공백만으로 구분 (보통의 함수형 언어)

```lean
#eval String.append("Hello, ", "Lean!") -- error!
#eval String.append "Hello, " "Lean!" -- "Hello, Lean!"
```

함수의 인자 자리에 **또 다른 식(함수 호출 등)**이 들어갈 때는 반드시 괄호를 쳐서 경계를 구분

```lean
#eval String.append "great " String.append "oak " "tree" -- error
#eval String.append "great " (String.append "oak " "tree") -- "great oak tree"
```

**문장(Statement) vs 식(Expression)**

- 명령형 언어 (C, Java 등): "만약 ~라면 A를 실행하고, 아니면 B를 실행해라"라는 **명령(Statement)**이 존재합니다. 결과값이 없을 수도 있습니다.
- Lean: 모든 것이 값을 가져야 하는 **식(Expression)**입니다. 따라서 Lean의 if는 "조건에 따라 이 값 혹은 저 값이 된다"는 의미이며, 반드시 결과를 반환합니다.
  - Lean은 식 중심의 함수형 언어이기 때문에 조건문은 존재하지 않으며, 오직 조건식만 존재
  - else를 생략할 수 없음

```lean
String.append "it is " (if 1 > 2 then "yes" else "no")
String.append "it is " (if false then "yes" else "no")
String.append "it is " "no"
```

### 1.1.1 Messages You May Meet

```lean
#eval String.append "it is "
-- could not synthesize a `ToExpr`, `Repr`, or `ToString` instance for type String → String
```

일부 인자만 적용된 Lean 함수는 나머지 인자를 기다리는 새로운 함수를 반환
-> Lean은 사용자에게 함수 자체를 (텍스트로) 표시할 수 없으므로, 함수를 표시하라는 요청을 받으면 오류를 반환

[Currying](https://en.wikipedia.org/wiki/Currying)

- 여러 인수를 포함하는 함수를 하나의 인수를 가진 함수군의 연속으로 변환하는 기법
- 커링된 함수에 인자를 일부분만 전달하는 행위를 부분 적용(partial application)이라고 부름

### 1.1.2 Exercises

```lean
#eval 42 + 19
#eval String.append "A" (String.append "B" "C")
#eval String.append (String.append "A" "B") "C"
#eval if 3 == 3 then 5 else 7
#eval if 3 == 4 then "equal" else "not equal"
```
