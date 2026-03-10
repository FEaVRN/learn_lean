## 1.3 함수와 정의 Functions and Definitions

**정의의 기본 문법**

- 구조: def [이름] : [유형] := [값]
- 연산자 구분:
  - `:=` (정의): 새로운 이름을 만들고 값을 할당할 때 사용합니다.
  - `=` (등식): 두 값이 수학적으로 같은지 비교하거나 증명할 때 사용합니다.

| 구분      | = (Equality)                           | == (Boolean Equality / BEq)          |
| --------- | -------------------------------------- | ------------------------------------ |
| 의미      | 수학적 명제: "두 값은 논리적으로 같다" | 결정 함수: "두 값이 같은지 확인해라" |
| 반환 타입 | Prop (명제)                            | Bool (true 또는 false)               |
| 용도      | 증명용 (논리적 성질 기술)              | 코드 실행용 (if문 등에서 사용)       |
| 특징      | 컴파일 타임에 존재 (실행 시 사라짐)    | 런타임에 실제로 계산됨               |

수학에서는 **"증명할 수는 있지만, 실제로 계산(알고리즘)할 수는 없는 것"**이 존재하기 때문에 분리

```lean
#check 2 + 2 = 4 -- Prop
#check 2 + 2 == 4 -- Bool
```

**Lean 정의의 특징**

- **유형 명시 권장**: 아주 단순한 경우가 아니면 : String처럼 타입을 적어주는 것이 좋습니다.
- **순차적 사용**: 반드시 먼저 정의되어야 아래 코드에서 사용할 수 있습니다. (Top-down 방식)
- **일관성**: 숫자, 문자열, 함수 모두 똑같이 def를 사용합니다. Lean에서는 **"모든 것이 값"**이기 때문입니다.
  - def hello := "Hello"는 호출할 때마다 계산을 새로 하는 함수가 아니라, "Hello"라는 데이터 그 자체를 가리키는 포인터와 같습니다.
  - 이는 프로그래밍 효율성 측면에서 "필요할 때마다 함수를 실행하는 비용"을 줄여줍니다.

```lean
def hello := "Hello"
def lean: String := "Lean"
#eval String.append hello (String.append ", " lean)
```

### 1.3.1 함수 정의하기 Defining Functions

**함수 정의의 기본 문법**

- 구조: def [함수명] ([인자1] : [타입]) ([인자2] : [타입]) : [반환타입] := [본문]
- 특징: C계열 언어의 f(x, y) 형태와 달리, 정의할 때도 호출할 때와 마찬가지로 인자들을 공백으로 나열합니다.

```lean
def add1 (n : Nat) : Nat := n + 1
#eval add1 7 -- 8

def maximum (n: Nat) (m: Nat): Nat :=
  if n < k then k
           else n

def spaceBetween (before: String) (after: String) : String :=
  String.append before (String.append " " after)
```

**함수의 평가 단계 (Substitution Model)**

Lean이 함수를 실행하는 논리적 순서

1. 인자 계산: 함수에 넘겨진 식들(예: 5 + 8)을 먼저 값으로 계산합니다.
2. 치환(Substitution): 함수의 본문에 있는 변수 이름들을 실제 값으로 갈아 끼웁니다.
3. 본문 실행: 치환된 식을 최종적으로 계산하여 결과값을 냅니다.

**함수의 타입 표기 (→)**

- 형식: [입력 타입] → [출력 타입]
- 예시:
  - Nat → Bool: 숫자를 넣으면 참/거짓이 나옴.
  - Nat → Nat → Nat: 숫자를 두 번 넣으면 숫자가 나옴.

**#check의 두 가지 모습**

```lean
#check add1 -- add1 (n: Nat) : Nat <<<<<< add1 function signature
#check (add1) -- add1: Nat -> Nat <<<<<<  anonymous expression
```

- `#check add1`: 함수의 '설명서'(이름, 변수명 포함)를 보여줌.
- `#check (add1)`: 함수의 순수한 '타입 체계'(Nat → Nat)를 보여줌.

**커링(Currying): Lean 함수의 본질**

Lean의 모든 함수는 사실 "인자를 단 한 개만" 받습니다.

1. maximum 3 4를 실행하면...
2. maximum 3이 먼저 실행되어 **"숫자 하나를 더 기다리는 새로운 함수"**가 만들어집니다.
3. 그 새로운 함수에 4가 들어가서 최종 결과가 나옵니다.

```lean
#check maximum 3
#check maximum 3 4
#check (maximum 3) 4
```

**우결합성 (Right Associativity)**
타입 표기에서 화살표는 오른쪽부터 묶입니다.

- Nat → Nat → Nat은 사실 **Nat → (Nat → Nat)**입니다.
- 해석: "숫자를 하나 주면(Nat →), '숫자를 받아 숫자를 내뱉는 함수'(Nat → Nat)를 돌려주겠다"는 뜻입니다.

#### 1.3.1.1 Exercise

Define the function joinStringsWith with type String → String → String → String that creates a new string by placing its first argument between its second and third arguments. joinStringsWith ", " "one" "and another" should evaluate to "one, and another".

```lean
def joinStringsWith (seperator: String) (s1: String) (s2: String) : String :=
  String.append s1 (String.append seperator s2)
```

What is the type of joinStringsWith ": "? Check your answer with Lean.

```lean
#check joinStringsWith ": " -- String -> String -> String
```

Define a function volume with type Nat → Nat → Nat → Nat that computes the volume of a rectangular prism with the given height, width, and depth.

```lean
def volumeOfRectangularPrism (height: Nat) (width: Nat) (depth: Nat): Nat :=
  height * width * depth

#eval volumeOfRectangularPrism 2 3 4
```

### 1.3.2 타입 정의하기 Defining Types

**일급 객체로서의 유형 (Types as First-Class)**
일반적인 언어에서 '데이터(값)'와 '타입'은 완전히 다른 세계의 존재입니다. 하지만 Lean에서는 이 경계가 없습니다.

- 값: "Hello", 5, true
- 유형: String, Nat, Bool

Lean의 관점: 위 둘 다 똑같이 def로 이름을 붙이고 조작할 수 있는 **식(Expression)**입니다.

**유형 별칭(Type Aliasing) 만들기**

방법: def [새 이름] : Type := [기존 타입]

원리: Lean은 코드를 실행하기 전에 Str이라는 이름을 발견하면 이를 원래 정의인 String으로 **치환(Substitution)**합니다.

```lean
def Str: Type := String
def aStr: Str := "This is a string"
#eval aStr
```

**Type**
def Str : Type := String에서 : Type은 Str의 타입의 타입을 말합니다.

- 5의 타입이 Nat이듯,
- Nat이나 String 같은 타입들의 타입은 **Type**입니다.

상황에 따라 타입 자체가 계산되어 변하는 아주 강력하고 복잡한 프로그램을 짤 수 있게 됩니다.

#### 1.3.2.1 Messages You May Meet

```lean
def NaturalNumber: Type := Nat
def thirtyEight: NaturalNumber := 38 -- failed to synthesize instance of type class OfNat NaturalNumber
-- 이 오류는 Lean이 숫자 리터럴의 오버로딩을 허용하기 때문에 발생

-- 1. 값의 명시적 타입 지정
def thirtyEight2: NaturalNumber := (38: Nat)
-- 2. NaturalNumber에 대해서 Number Literal의 Overloading 정의
sorry
-- 3. def 대신 abbrev 사용
abbrev N : Type := Nat
def thirtyNine : N := 39
-- 정의된 이름이 본래의 정의로 교체될 수 있습니다. abbrev로 작성된 정의는 항상 즉시 펼쳐집
```

> abbrev >>>> Abbreviation (줄임말)

**가약성 (Reducibility) 이란?**

- Reducible (가약 可約): abbrev로 만든 것. 컴파일러가 필요할 때마다 즉시 본래 내용으로 펼쳐서 확인합니다. (**유연함**)
- Semireducible (반가약): def로 만든 것. 특별한 요청이 없으면 본래 내용을 숨깁니다. (**성능** 및 깔끔한 오류 메시지 유지에 유리)
