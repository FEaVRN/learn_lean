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

<!-- TODO -->