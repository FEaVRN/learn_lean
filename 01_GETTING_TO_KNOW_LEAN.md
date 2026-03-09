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

## 1.2 타입 Types

유형(Type)의 4가지 주요 역할

- **효율성**: 메모리를 얼마나 쓸지 컴파일러가 판단하게 함.
- **소통**: 함수의 입출력을 명시하여 "설명서"(specification) 역할을 함.
- **안전성**: 타입이 맞지 않는 연산을 원천 차단하여 버그를 줄임.
- **자동화**: 반복되는 코드를 컴파일러가 대신 짜게 해줌.

Lean 유형 시스템의 특별함 >> **의존 유형(Dependent Types)**의 정수

- **강력한 보장**: 함수가 단순히 '리스트'를 내뱉는다고 하는 게 아니라, "정확히 정렬된 결과물이다"라는 **논리적 증명을 타입에 심을 수** 있습니다.
- **유연성**: **입력값이 무엇이냐에 따라 출력되는 타입 자체가 바뀔 수** 있습니다.
- **증명 도구**: **타입 시스템 자체가 수학적 공식을 증명**하는 논리 언어로 작동합니다.

```lean
-- '정렬된 리스트'라는 새로운 타입을 정의한다고 가정해봅시다.
-- 이 타입은 단순한 리스트가 아니라, "정렬됨"이라는 성질을 만족해야만 생성 가능합니다.

def sort (l : List Nat) : { res : List Nat // IsSorted res ∧ Permutation l res } :=
  sorry
  -- 여기에 정렬 알고리즘을 구현합니다.
  -- 구현이 완벽하지 않으면(즉, 증명이 불가능하면) 이 함수는 컴파일되지 않습니다.
```

어떻게 이것이 가능한가?

- Curry-Howard Correspondence
  - 커리-하워드 동형사상
  - 컴퓨터 프로그램과 수학적 증명 간의 직접적인 관계를 의미
  - 동치성(equivalence), 또는 증명을 프로그램으로서 보고, 명제나 공식을 타입으로서 해석하는 해석
- Lean에서는 **"명제(수학적 사실)는 타입과 같고, 증명은 그 타입의 값과 같다"**는 원리를 사용

**유형 명시하기 (Type Annotation)**

- 문법: (식 : 유형)
- 필요성: Lean이 타입을 자동으로 추론하지 못하거나, 개발자가 특정 타입을 강제하고 싶을 때 사용합니다.

```lean
#eval (1 + 2 : Nat)
```

| 타입 | 의미                      | 특징              | 1 - 2 의 결과        |
| ---- | ------------------------- | ----------------- | -------------------- |
| Nat  | 자연수 (0,1,2, ...)       | 기본값, 음수 없음 | 0 (음수로 가지 않음) |
| Int  | 정수 (..., -1, 0, 1, ...) | 음수 표현 가능    | -1                   |

> 현대의 수학자들은 페아노 공리계가 갖는 비엄밀한 부분을 해결하기 위해, 집합론을 사용하여 0부터 시작하여 1, 2, 3, ⋯ 등으로 수를 정의하였다.
> 나무위키 - 자연수 3.2 범자연수 (0을 포함하는 자연수)

**#check 명령어**

- 역할: 식을 실제로 실행(계산)하지 않고, 그 식의 **유형(Type)**이 무엇인지만 확인합니다.
- 용도: 복잡한 함수가 어떤 결과를 내놓을지 '설계도'만 미리 보고 싶을 때 유용합니다.

```lean
#check (1 - 2 : Int) -- 1 - 2 : Int

-- 잘못된 타입의 인자를 함수에 적용
#check String.append ["hello", " "] "world"
-- Application type mismatch: The argument ...
-- 유형을 부여할 수 없는 경우, #check와 #eval 모두에서 오류가 반환
```

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


## 1.4 Structures

**구조체(structure)**

- 여러 개의 독립적인 데이터를 하나의 새로운 타입으로 묶는 방법
- 여러 값을 하나의 의미 있는 단위로 결합
- 여러 값을 하나의 타입으로 묶는 타입을 product type

```lean
structure Point where
  x: Float
  y: Float


def origin : Point := { x:= 0.0, y:= 0.0 }
def origin2 := ({ x := 0.0, y := 0.0 } : Point)
-- 중괄호 안에 타입 선언
def origin3 := {x := 0.0, y:= 0.0 : Point}

def origin := { x:= 0.0, y:= 0.0 } -- error
```

Lean은 구조체 정의 시 자동으로 accessor 함수를 생성

```lean
-- 동일
#eval Point.x origin
#eval origin.x 

-- 동일
#eval Point.y origin
#eval origin.y
```

함수 선언

```lean
def addPoints (p1 : Point) (p2 : Point) : Point :=
  { x := p1.x + p2.x, y := p1.y + p2.y }
```

### 1.4.1 구조체 갱신 Updating Structures

기존 값을 기반으로 일부 필드를 변경한 새로운 값을 반환
 
Lean은 기본적으로 모든 값이 immutable

```lean 
def zeroX (p: Point) : Point :=
  { p with x := 0.0 }

def fourAndThree : Point :=
  { x := 4.3, y := 3.4 }

#eval fourAndThree -- { x:= 4.3, y:= 3.4}
#eval zeroX fourAndThree -- { x:= 0.0, y:= 3.4}
#eval fourAndThree -- { x:= 4.3, y:= 3.4}
```

### 1.4.2 구조체 네임스페이스 Behind the Scenes

구조체를 정의하면 namespace도 자동 생성

```lean
Point.x
Point.y
Point.mk
```

생성자 이름 변경을 위해서는 아래와 같이 선언

```lean
structure Point2 where
  point ::
  x: Float
  y: Float

#eval {x := 0.0, y := 0.0 : Point2}
#eval Point2.point 0.0 0.0
```

메소드 방식으로도 사용 가능

`TARGET.f ARG1 ARG2 ...` 일때 `TARGET`의 타입이 `T`라면 `T.f`라는 이름의 함수가 호출된다.

`TARGET`은 함수의 **`T` 타입을 요구하는 가장 왼쪽 인자**로 전달

```lean
#eval "Hello, ".append "world!" -- "Hello, world!"

-- String.append [String (Hello, )] [String (world!)]
```

구조체 네임스페이스 안에 함수 선언

```lean
def Point.modifyBoth (f: Float → Float) (p: Point) : Point :=
  { x := f p.x, y := f p.y }

#eval fourAndThree.modifyBoth Float.floor
-- Point.modifyBoth [(f: Float → Float) (Float.floor)] [(p: Point) fourAndThree]
```

### 1.4.3 Exercises 

Define a structure named RectangularPrism that contains the height, width, and depth of a rectangular prism, each as a Float.

```lean
structure RectangularPrism where
  height: Float
  width: Float
  depth: Float
```


Define a function named volume : RectangularPrism → Float that computes the volume of a rectangular prism.

```lean
def RectangularPrism.volume (rp: RectangularPrism) : Float :=
  rp.height * rp.width * rp.depth
```

Define a structure named Segment that represents a line segment by its endpoints, and define a function length : Segment → Float that computes the length of a line segment. Segment should have at most two fields.

```lean
structure Segment where
  p1: Point
  p2: Point

def Segment.length (s: Segment) : Float :=
  let dx := s.p2.x - s.p1.x
  let dy := s.p2.y - s.p1.y
  Float.sqrt (dx * dx + dy * dy)
```

Which names are introduced by the declaration of RectangularPrism?

- mk
- height
- width
- depth

Which names are introduced by the following declarations of Hamster and Book? What are their types?

```lean
structure Hamster where
  name : String
  fluffy : Bool
structure Book where
  makeBook ::
  title : String
  author : String
  price : Float
```

Hamster 

- mk: String -> Bool -> Hamster
- name: Hamster -> String
- fluffy: Hamster -> Bool

Book

- makeBook: String -> String -> Float -> Book
- title: Book -> String
- author: Book -> String
- price: Book -> Float


## 1.5 데이터 타입과 패턴 Datatypes and Patterns

**Sum type(합 타입)** 

- 여러 선택지 중 하나를 가질 수 있는 데이터 타입

- **도메인 개념(domain concepts)** 자연스럽게 표현

```lean
inductive User where
  | owner
  | editor
  | viewer

inductive Operator where
  | addition
  | subtraction
  | multiplication
  | division
```

- 재귀적인 sum type은 **inductive datatype(귀납적 데이터 타입)**
- **임의 개수의 요소를 포함**할 수 있는 데이터
- 이러한 타입들에 대해 **수학적 귀납법(mathematical induction)**을 사용하여 명제를 증명
- inductive datatype은 **pattern matching(패턴 매칭)** 과 **재귀 함수(recursive functions)** 를 통해 사용(소비)

```lean
inductive MyList (α: Type) where
  | nil: MyList α
  | cons: α -> MyList α -> MyList α

def xs : MyList Nat :=
  MyList.cons 1 (MyList.cons 2 (MyList.cons 3 MyList.nil))
```

여러 내장 타입도 inductive datatype으로 정의되어 있음

```lean 
inductive Bool where
  | false : Bool
  | true : Bool
```

구조체(structure)의 constructor와 마찬가지로, inductive datatype의 constructor 역시 다른 데이터를 받아 저장하는 단순한 수단일 뿐 임의의 초기화 코드나 검증 코드를 넣는 장소가 아니다.

inductive datatype은 여러 개의 constructor를 자기 타입 네임스페이스 내에 가진다. Bool의 경우 인자를 받지 않는 constructor `Bool.true`, `Bool.false`.

Lean 표준 라이브러리에서는 true와 false가 이 namespace에서 재-export되어 `Bool.` 없이 사용 가능

OOP 에서는 아래와 같이 사용 가능

```csharp
abstract class Bool {}
sealed class True : Bool {}
sealed class False : Bool {}
```

이 객체지향 예제에서는 True와 False가 모두 Bool보다 더 구체적인 타입이 된다.
반면 Lean의 정의에서는 새로운 타입은 Bool 하나만 도입된다.