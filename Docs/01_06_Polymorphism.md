## 1.6 Polymorphism 다형성

Lean에서도 대부분의 언어와 마찬가지로 타입은 인자(argument)를 받을 수 있다.

Lean이 함수에 인자를 전달할 때 공백을 사용하듯, 타입에 인자를 전달할 때도 공백을 사용

- `List Nat`: 자연수 리스트 (C#: `List<Nat>`)
- `List List Nat` : 자연수 리스트의 리스트 (C#: `List<List<Nat>>`)


**(형식) 매개변수 다형성 (Parametric Polymorphism)**

함수형 프로그래밍에서 polymorphism이라는 말은 보통 **타입을 인자로 받는 데이터 타입과 정의**

- `List String`
- `Option Nat`

**서브타입 다형성 (Subtype Polymorphism)**

객체지향 커뮤니티에서 이 용어가 보통 슈퍼클래스의 동작을 오버라이드할 수 있는 서브클래스를 뜻하는 것과는 다름

**임의 다형성 (Ad-hoc Polymorphism)**

- "Ad-hoc"은 '특별한 목적을 위해'라는 뜻
- 타입에 따라 서로 다른 구현을 실행하는 방식

```rust
// 1. 트레이트 정의 (기능 명세)
trait Summary {
    fn summarize(&self) -> String;
}

struct NewsArticle {
    headline: String,
    content: String,
}

// 2. NewsArticle에 대한 "특별한(Ad-hoc)" 구현
impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("뉴스: {}", self.headline)
    }
}

struct Tweet {
    username: String,
    content: String,
}

// 3. Tweet에 대한 "특별한(Ad-hoc)" 구현 (로직이 다름!)
impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}

// 사용 시점: 인자의 타입에 따라 다른 summarize()가 실행됨
fn print_summary(item: &impl Summary) {
    println!("{}", item.summarize());
}
```

Point의 다형적 버전인 PPoint는 타입을 인자로 받아서 그 타입을 두 필드에 사용

```lean
structure PPoint (α: Type) where
  x: α
  y: α
```

Lean에서는 타입 인자 이름으로 그리스 문자를 쓰는 것이 관례

정의(definition, 선언)도 타입을 인자로 받을 수 있으며, 그러면 그 정의는 다형적이 된다.

```lean
def replaceX (α: Type) (p: PPoint α) (newX: α): PPoint α :=
  { p with x := newX }

#check replaceX -- (α : Type) → PPoint α → α → PPoint α
#check replaceX Nat -- PPoint Nat -> Nat -> PPoint Nat

replaceX natOrigin 5 -- error

#check replaceX Nat natOrigin -- Nat -> PPoint Nat
#check replaceX Nat natOrigin 5 -- PPoint Nat
#eval replaceX Nat natOrigin 5 -- { x:= 5, y:= 0 : PPoint Nat }
```


```lean
inductive Sign where
  | pos
  | neg

-- Return Type이 Sign에 따라 달라지는 다형적 정의
def posOrNegThree (s : Sign):
  match s with
  | Sign.pos => Nat
  | Sign.neg => Int :=
  match s with
  | Sign.pos => 3
  | Sign.neg => -3
```

Lean에서는 Type도 first-class citizen!

데이터타입에 대한 패턴 매칭으로 타입 자체를 계산할 수도 있음.


### 1.6.1 Linked List 연결 리스트


**List**
- 표준 내장
- 연결 리스트(linked list)
- 귀납적 데이터타입
- literal 특수 문법 : `[]`

```lean
def primesUnder10: List Nat := [2, 3, 5, 7]

inductive List (α : Type) where
  | nil : List α
  | cons : α → List α → List α
--       HEAD -> TAIL -> List α (RETURN)

def explicitPrimesUnder10: List Nat :=
  List.cons 2 (List.cons 3 (List.cons 5 (List.cons 7 List.nil)))
```

List.length 를 재구현

```lean
def length (α: Type) (xs: List α): Nat :=
  match xs with
  | List.nil => 0
  | List.cons y ys => 1 + length α ys -- Nat.succ (length α ys)

#eval length String ["Sourdough", "Bread"]
```

List에는 특수 문법이 존재 => 더 범용적인(수학적인) 표기법
```lean
def nats := 4::5::3::[]
#eval nats -- [4, 5, 3] : List Nat

def length2 (α: Type) (xs: List α): Nat :=
  match xs with
  | [] => 0
  | y::ys => 1 + length2 α ys
```

## 1.6.2 Implicit Arguments 암시적 인자

타입 인자가 보통 뒤의 값들로부터 유일하게 결정되는 경우가 많음

```typescript
// TypeScript에서 제네릭 함수 정의
function length<T>(xs: T[]): number {
  if (xs.length === 0) {
    return 0;
  } else {
    return 1 + length(xs.slice(1));
  }
}

length([1, 2, 3]); // T는 자동으로 Number으로 추론됨
```

소괄호 대신 중괄호로 감싸면 암시적(implicit) 인자로 선언

```lean 
def length3 {α: Type} (xs: List α): Nat :=
  match xs with
  | [] => 0
  | y::ys => 1 + length3 ys

#eval length3 String ["Sourdough", "Bread"] --error
#eval length3 (α := String) ["Sourdough", "Bread"] -- 2
#eval length3 ["Sourdough", "Bread"] -- 2
```

length3 가 List.length와 동일한 역할

Lean도 항상 암시적 인자를 찾을 수 있는 것은 아님.

이런 경우에는 인자 이름을 써서 제공해야 함.

```lean 
#check List.length (α := String) -- List String -> Nat
```

### 1.6.3 More Built-In Datatypes 더 많은 내장 데이터 타입

#### Option

- 많은 언어는 값의 부재를 나타내는 null을 갖지만
- Lean은 기존 타입에 특별한 null 값을 추가하는 대신 Option이라는 데이터타입을 제공
- null 가능성을 새 타입(Option α)으로 나타내면, 타입 시스템이 null 체크를 빠뜨리지 못하게 강제 
  - Int 값이 들어갈 곳에 Option Int 값이 들어갈 수 없기 때문

```lean
inductive Option (α : Type) where
  | none : Option α
  | some (val : α) : Option α
```

- 리스트의 첫 원소가 있으면 그것을 찾기 위해 List.head?를 씀
- head? 의 ?가 특별한 문법은 아님

```lean
def List.myhead? {α: Type} (xs: List α): Option α :=
  match xs with
  | [] => Option.none
  | y::_ => Option.some y
```

**Lean의 명명 관례**

- ? 버전은 Option 반환
- ! 버전은 Option이 아닌 타입을 반환 (예외 발생 가능)
- D 버전은 기본값 반환

```lean
#check List.head! -- List α -> α
#check List.head? -- List α -> Option α
#check List.headD -- List α -> α -> α

#eval List.headD [] "No bread"

#eval primesUnder10.head? -- some 2 : Option Nat
```

빈 리스트 [].head?를 테스트하면 에러 발생

빈 리스트만으로는 원소 타입을 알 수 없어서 표현식의 타입을 결정하지 못하기 때문

```lean
[].head? -- error
```

```
-- 암시적 인자를 합성(추론)하는 방법을 모르겠습니다.

don't know how to synthesize implicit argument `α`
  @List.nil ?m.3
context:
⊢ Type ?u.4939Lean 4
```

Lean 출력에서 ?m.XYZ는 추론되지 못한 부분을 뜻하며 이를 metavariable이라고 함. 

타입을 명시적으로 주면 해결

```lean
#eval [].head? ( α := Nat ) -- implicit argument 명시
#eval ([]: List Nat).head? -- List 타입을 explicit하게 명시
```

두 에러 메시지가 같은 metavariable을 사용한다는 점은, Lean이 두 미결정 조각이 **같은 해를 공유** 해야 한다는 사실까지는 알았다는 뜻이다. 

다만 그 실제 값을 알아내지 못했을 뿐


#### Prod

두 값을 일반적으로 묶는 타입

tuple, pair, product type 등으로도 불림

```lean
structure Prod (α: Type) (β: Type) where
  fst: α
  snd: β
```

Prod α β는 보통 α × β라고 씀

수학적인 쌍 표기 (a, b)를 쓸 수 있음

```lean
def pair := (4,5)
#check pair -- Nat × Nat
def pair2 := Prod.mk 6 7
#check pair2 -- Nat × Nat

def fives: String × Int := {
  fst := "Five"
  snd := 5
}
#check fives

def fives' : String × Int := ("Five", 5)
#check fives'
```

곱 타입 표기와 생성자 표기는 오른쪽 결합(right-associative)

세 개 이상의 곱은 사실상 **중첩된** 곱

```lean
def sevens: String × Int × Nat := ("VII", 7, 4 + 3)
def sevens' : String × Int × Nat := ("VII", (7, 4 + 3))
```

triple, quadruple, n-tuple 등도 Prod의 중첩으로 표현 가능 (이 따로 없다는 얘기)


#### Sum

Sum은 서로 다른 두 타입 중 하나를 선택하게 하는 일반 타입

- Sum String Int는 문자열이거나 정수 (ts: `string | number`)
- 아주 일반적인 코드나 매우 작은 범위의 코드, 또는 표준 라이브러리 편의 함수가 유리한 경우에 적합
- 대부분의 실제 코드에서는 목적이 더 잘 드러나는 사용자 정의 inductive type이 더 읽기 쉽다
- Sum α β는 α ⊕ β라고도 씀
- 다른 언어에서는 Either, Variant, Union 등으로 불리는 타입과 유사

```lean
inductive Sum (α : Type) (β : Type) : Type where
  | inl : α → Sum α β -- left injection
  | inr : β → Sum α β -- right injection

def leftValue : Sum String Int := Sum.inl "Hello"
def rightValue : Sum String Int := Sum.inr 42

def checkSum (s : Sum String Int) : String :=
  match s with
  | Sum.inl s => "문자열이 들어있네요: " ++ s
  | Sum.inr n => "숫자가 들어있네요: " ++ toString n

#eval checkSum leftValue   -- "문자열이 들어있네요: Hello"
#eval checkSum rightValue  -- "숫자가 들어있네요: 42"

def PetName : Type := String ⊕ String -- type alias 
-- PetName이 개 이름이면 Sum.inl, 고양이 이름이면 Sum.inr로 표현
def animals : List PetName :=
  [Sum.inl "Spot", Sum.inr "Tiger", Sum.inl "Fifi", Sum.inl "Rex", Sum.inr "Floof"]

-- PetName 리스트에서 개 이름이 몇 개인지 세는 함수
-- Sum.inl이 개 이름이므로, 패턴 매칭으로 개 이름을 세면 됨
def howManyDogs (pets : List PetName) : Nat :=
  match pets with
  | [] => 0
  | Sum.inl _ :: morePets => howManyDogs morePets + 1
  | Sum.inr _ :: morePets => howManyDogs morePets
```

#### Unit

Unit은 인자를 받지 않는 생성자 unit 하나만 가진 타입

값이 정확히 하나뿐인 타입

```lean
inductive Unit : Type where
  | unit : Unit
```

1. 다형적 코드에서는 “비어 있는 자리 표시자”로 자주 사용
    - Option.none의 경우 항상 some인지 체크해야하지만 Unit.unit은 항상 unit이므로 체크할 필요가 없음
2. 반환위치에서는 C 언어 계열의 void와 유사한 역할을 함
    - 함수가 아무 의미 있는 값을 반환하지 않는다는 것을 나타냄

#### Empty

Empty는 생성자가 전혀 없는 타입

어떤 호출 열도 Empty 타입의 값으로 끝날 수 없으므로, 도달 불가능한 코드

TypeScript의 never 타입과 유사

```lean
inductive Empty : Type where
  -- 생성자가 없음
```

#### Naming: Sums, Products, and Units

- Sum type: 여러 생성자를 가진 타입
- Product type: 하나의 생성자가 여러 인자를 받는 타입

이 용어는 산술의 합과 곱에서 왔음

α -> n개, β -> k개의 구별되는 값을 가진다면

- Sum type α ⊕ β = n + k개의 구별되는 값을 가짐
- Product type α × β = n * k개의 구별되는 값을 가짐

### 1.6.4 Messages You May Meet

정의 가능한 모든 구조체나 귀납 타입이 Type이라는 타입을 가질 수 있는 것은 아님

특히, 어떤 생성자가 임의의 타입을 인자로 받는다면, 그 귀납 타입은 다른 타입을 가져야 함

```lean
inductive MyType: Type where
  | ctor: (α: Type) -> α -> MyType
```

```
Invalid universe level in constructor `MyType.ctor`: Parameter `α` has type
  Type
at universe level
  2
which is not less than or equal to the inductive type's resulting universe level 
  1
```

나중에 설명해준다고함...?

```lean
| ctor : (α : Type) → α → MyType
```

이 정의는 생성자 ctor가
- 타입 α 하나를 받고
- 그 타입의 값 하나를 받고
- MyType을 만든다

즉 MyType 안에 아무 타입이나 다 집어넣을 수 있게 하려는 것이다.

하지만 Lean은 이 경우 MyType : Type처럼 낮은 universe에 그냥 둘 수 없다고 본다.
그래서 에러가 난다.

당장은, 타입을 생성자의 인자로 넣기보다는, 귀납 타입 전체의 인자로 만들도록 해 보라.

```lean
inductive MyType (α: Type): Type where
  | ctor: (a: α) -> MyType α
```

---

비슷하게, 어떤 생성자의 인자가 지금 정의하고 있는 데이터타입을 인자로 받는 **함수**  라면, 그 정의는 거부

```lean
inductive MyType : Type where
  | ctor : (MyType → Int) → MyType
--          ^^^^^^^^ 함수
```

```
(kernel) arg #1 of 'MyType.ctor' has a non positive occurrence of the datatypes being declared
```

기술적인 이유 때문에, 이런 데이터타입들을 허용하면 Lean의 **내부 논리(internal logic)** 를 무너뜨릴 수 있게 될 수도 있다.

그렇게 되면 Lean은 **정리 증명기(theorem prover)** 로 사용하기에 적합하지 않게 된다.

---

두 개의 매개변수를 받는 재귀 함수는 그 둘을 하나의 쌍(pair)으로 매칭하지 말고,
각 매개변수에 대해 독립적으로 패턴 매칭해야 한다.

그렇지 않으면 Lean에서 **재귀 호출이 더 작은 값에 대해 이루어지는지 검사** 하는 메커니즘이 입력 값과 재귀 호출에서 사용되는 인자 사이의 관계를 파악할 수 없게 된다.

> Lean이 종료를 확인하는 원리는 [웰-파운디드 관계(Well-founded relation)](https://en.wikipedia.org/wiki/Well-founded_relation)$\prec$를 찾는 것

```lean
-- {α: Type} {β: Type} 안써도 알아서 컴파일러가 implicit argument로 인식해서 처리해줌
def sameLength (xs: List α) (ys: List β): Bool :=
  match (xs, ys) with
  | ([], []) => true
  | (x::xs', y::ys') => sameLength xs' ys'
  | _ => false
```

```
fail to show termination for
  sameLength
with errors
failed to infer structural recursion:
Not considering parameter α of sameLength:
  it is unchanged in the recursive calls
Not considering parameter β of sameLength:
  it is unchanged in the recursive calls
Cannot use parameter xs:
  failed to eliminate recursive application <<<<<< 여기
    sameLength xs' ys'
Cannot use parameter ys:
  failed to eliminate recursive application <<<<<< 여기
    sameLength xs' ys'


Could not find a decreasing measure. <<<<<<<<<<<<<< 여기
The basic measures relate at each recursive call as follows:
(<, ≤, =: relation proved, ? all proofs failed, _: no proof attempted)
              xs ys
1) 1816:28-46  ?  ?
Please use `termination_by` to specify a decreasing measure.
```

**설명 1**

1. (xs, ys)로 묶는 순간 Lean은 두 리스트를 개별적으로 추적하지 않고, 임시로 생성된 하나의 Prod 값으로 취급한다.
2. 컴파일러는 이 임시 튜플이 '원래 함수의 인자'가 아니기 때문에, 여기서부터 시작되는 구조적 감소를 추적할 수 없다.
3. 즉, "xs'가 튜플에서 분해되어 나온 건 알겠는데... 이게 원래 함수의 인자인 xs에서 바로 유래한 건지 확신할 수 없네?" 하고 연결 고리(Structural trace)를 놓쳐버린다.
4. 그래서 match 분기에서 제공하는 정보만으로는 xs → xs' 같은 구조적 감소 관계를 직접 인식(증명)하지 못하고 에러를 발생시킨다.

**설명 2**

- Lean은 재귀 함수에서 재귀 호출 시 인자가 구조적으로 감소하는지 확인해야 한다.
- sameLength : List α → List β → Bool 에서 termination checker는 다음 중 하나를 증명해야 한다.
  - xs' < xs
  - ys' < ys
- match (xs, ys) 패턴에서는 (xs, ys)가 하나의 Prod 값으로 패턴 매칭된다.
- 패턴 (x :: xs', y :: ys')는 내부적으로 Prod.mk (List.cons x xs') (List.cons y ys') 구조이다.
- 이 패턴 매칭이 성공하면 Lean의 타입 검사 단계에서는 다음 관계가 성립한다.
  - xs = x :: xs'
  - ys = y :: ys'
- 그러나 termination checker는 (xs, ys) 패턴에서 나온 xs'가 함수 인자 xs의 **직접적인 구조적 하위(subterm) 라는 관계를 자동으로 복원하지 못한다.**
- 따라서 termination checker는 재귀 호출 sameLength xs' ys'가 원래 호출보다 작다는 것을 증명하지 못한다.
- 결과적으로 Lean은 구조적 감소를 확인할 수 없다고 판단하여 termination error를 발생시킨다.


```lean
def sameLength2 (xs: List α) (ys: List β): Bool :=
  match xs with
  | [] =>
    match ys with
    | [] => true
    | y::ys' => false
  | x::xs' =>
    match ys with
    | [] => false
    | y::ys' => sameLength2 xs' ys'

#eval sameLength2 [1, 2, 3] ["a", "b", "c"] -- true
```

---

귀납 타입(inductive type)에 대한 인자를 빠뜨리는 것도 혼란스러운 메시지

```lean
inductive MyType3 (α: Type) : Type where
  | ctor : α -> MyType3 
-- error
-- MyType3 \alpha 로 적어야함
```

```
type expected, got
  (MyType : Type → Type)
```

타입 인자를 생략했을 때 나타날 수 있음
```lean
inductive MyType4 (α: Type) : Type where
  | ctor : α -> MyType4 α

def ofFive: MyType4 := MyType4.ctor 5 -- error

def ofFive2 := MyType4.ctor 5 --ok
def ofFive3 : MyType4 Nat := MyType4.ctor 5 --ok
```

---

inductive 타입에 대해서 종종 #eval 명령이 Repr, ToString 이 없어서 작동하지 않을때 있음

(대부분 자동으로 display 해주지만)

```lean
inductive WoodSplittingTool where
  | axe
  | maul
  | froe

#eval WoodSplittingTool.axe

def allTools : List WoodSplittingTool := [
  WoodSplittingTool.axe,
  WoodSplittingTool.maul,
  WoodSplittingTool.froe
]

#eval allTools -- error
```


#eval 시점에 즉석에서 생성하는 대신 Lean에게 표시 코드를 미리 생성하도록 지시함으로써 해결

```lean
inductive WoodSplittingTool2 where
  | axe
  | maul
  | froe
deriving Repr

def allTools2 := [
  WoodSplittingTool2.axe,
  WoodSplittingTool2.maul,
  WoodSplittingTool2.froe
]

#eval allTools2
```

deriving 문법은 Haskell 과 비슷

```haskell
data Firewood
  = Birch
  | Pine
  | Beech
  deriving (Show)
```

- Lean deriving은 compile-time metaprogramming
- deriving을 쓰면 해당 타입클래스의 instance가 자동으로 생성
- lean 소스코드가 생성되지는 않고 AST 수준의 표현이 생성되어 컴파일러가 직접 처리


### 1.6.5 Exercises 연습문제

Write a function to find the last entry in a list. It should return an Option.

```lean
def last {α: Type} (xs: List α): Option α :=
   match xs with
   | [] => Option.none
   | [x] => Option.some x
   | _::xs' => last xs'
```

Write a function that finds the first entry in a list that satisfies a given predicate. Start the definition with def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α := ….

```lean
def List.findFirst {α: Type} (xs: List α) (predicate: α -> Bool) : Option α :=
  match xs with
  | [] => Option.none
  | x::xs' => if predicate x then Option.some x else List.findFirst xs' predicate
```

Write a function Prod.switch that switches the two fields in a pair for each other. Start the definition with def Prod.switch {α β : Type} (pair : α × β) : β × α := ….

```lean
def Prod.switch {α: Type} {β: Type} (pair: α × β): β × α :=
  match pair with
  | (a, b) => (b, a)
```

Rewrite the PetName example to use a custom datatype and compare it to the version that uses Sum.

```lean
inductive PetNameInductive
  | dog (name: String): PetNameInductive
  | cat: String -> PetNameInductive

#eval PetNameInductive.dog "hi"
#eval PetNameInductive.cat "nyooo"
```

Write a function zip that combines two lists into a list of pairs. The resulting list should be as long as the shortest input list. Start the definition with def zip {α β : Type} (xs : List α) (ys : List β) : List (α × β) := ….

```lean
def zip {α: Type} {β: Type} (xs: List α) (ys: List β) : List (α × β) :=
  match xs with
  | [] => []
  | x::xs' =>
    match ys with
    | [] => []
    | y::ys' => (x, y)::(zip xs' ys')
```

Write a polymorphic function take that returns the first n entries in a list, where n is a Nat. If the list contains fewer than n entries, then the resulting list should be the entire input list. #eval take 3 ["bolete", "oyster"] should yield ["bolete", "oyster"], and #eval take 1 ["bolete", "oyster"] should yield ["bolete"].

```lean
def take {α: Type} (n: Nat) (xs: List α) : List α :=
  if n == 0
  then []
  else
    match xs with
    | [] => []
    | x::xs' => x::(take (n - 1) xs')
```

Using the analogy between types and arithmetic, write a function that distributes products over sums. In other words, it should have type α × (β ⊕ γ) → (α × β) ⊕ (α × γ).

```lean
def distributeProductsOverSums (p: α × (β ⊕ γ)) : (α × β) ⊕ (α × γ) :=
  match p with
  | (a, Sum.inl left) => Sum.inl (a, left)
  | (a, Sum.inr right) => Sum.inr (a, right)
```

Using the analogy between types and arithmetic, write a function that turns multiplication by two into a sum. In other words, it should have type Bool × α → α ⊕ α.

```lean
def multiplicationByTwoIntoSum (p: Bool × α) : α ⊕ α :=
  match p with
  | (true, a) => Sum.inl a
  | (false, a) => Sum.inr a
```