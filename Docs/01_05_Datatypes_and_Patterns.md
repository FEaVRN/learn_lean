
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

범자연수 (0 ~ ) Nat 타입도 귀납적 데이터 타입으로 정의되어 있음

zero는 0을 나타내고, succ는 어떤 다른 수의 후속자(successor)

```lean
inductive Nat where
  | zero : Nat
  | succ (n: Nat): Nat -- 인자를 받는다.

-- Nat.zero == 0
-- Nat.succ Nat.zero == 1
-- Nat.succ (Nat.succ Nat.zero) == 2
-- Nat.succ (Nat.succ (Nat.succ Nat.zero)) == 3 
```

OOP에서의 Nat

```csharp
abstract class Nat {}

class Zero : Nat {}
class Succ : Nat {
    public Nat n;
    public Succ(Nat pred) {
        n = pred;
    }
}
```

TypeScript에서의 Nat

```typescript
interface Zero {
  tag: "zero";
}
interface Succ {
  tag: "succ";
  predecessor: Nat;
}

type Nat = Zero | Succ;
```

[Church Encoding](https://en.wikipedia.org/wiki/Church_encoding) - 람다 대수에서 다양한 데이터 타입을 (함수로?) 표현하는 방법


### 1.5.1 패턴 매칭 Pattern Matching

- 1)타입 검사와 2)값 추출 을 동시에 하는 강력한 도구

```lean
def isZero (n: Nat): Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ _ => false -- `_`는 와일드카드 패턴으로, 어떤 값이든 상관없음을 나타냄
```

위 코드에서는 n이 Nat.zero 생성자로 생성되었는지, 아니면 Nat.succ 생성자로 생성되었는지를 검사

```lean
isZero 5

isZero (Nat.succ (Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))))

match Nat.succ (Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))) with
| Nat.zero => true
| Nat.succ k => false
false
```

패턴매칭에서 생성자에 입력된 인자를 사용할 수 있음

```lean
def pred (n: Nat): Nat :=
  match n with
  | Nat.zero => Nat.zero
  | Nat.succ m => m

#eval pred 5
#eval pred (Nat.succ 4)
```

구조체에도 사용 가능

```lean
structure Point3D where
  x: Float
  y: Float
  z: Float

def depth (p : Point3D) : Float :=
  match p with
  | { x := h, y := w, z := d } => d
```

### 1.5.2 재귀 함수 (Recursive Functions)

정의되는 이름을 참조하는 정의를 재귀 정의(recursive definition)

귀납 데이터타입은 재귀적일 수 있음 
- 재귀적인 Sum Type => 귀납 데이터타입
- Nat은 succ가 또 다른 Nat을 요구

재귀 데이터타입은 이용 가능한 메모리 같은 기술적 요인에 의해 제한될 뿐, 임의로 큰 데이터를 나타낼 수 있음

자연수 각각에 대해 데이터타입 정의에 생성자 하나씩을 적어 넣는 것이 불가능하듯, 각 가능성마다 패턴 매칭 케이스를 하나씩 적어 넣는 것도 불가능

```lean
def even (n: Nat): Bool :=
  match n with
  | Nat.zero => true -- 기저 사례(base case)
  | Nat.succ m => not (even m) -- even 선언 안에서 even을 참조하는 재귀적 정의
```

1. Nat.zero에 대해 무엇을 할지를 식별
1. 어떤 임의의 Nat에 대한 결과를 그 successor에 대한 결과로 어떻게 변환할지를 결정
1. 이 변환을 재귀 호출의 결과에 적용

=> 이 패턴을 **구조적 재귀(structural recursion)** 라고 함

많은 언어와 달리, Lean은 기본적으로 모든 재귀 함수가 결국 **기저 사례에 도달함을 보장**

단순히 inductive type의 각 생성자 패턴 매칭만 하는지 체크하는 수준을 넘어섬

```lean
def evenLoop (n: Nat): Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ m => not (evenLoop n) -- 무한 루프에 빠짐
-- fail to show termination for evenLoop
```

Nat의 더하기 재귀 함수에서의 기저 사례 도달 분석 

```lean
def plus (n: Nat) (k: Nat): Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => Nat.succ (plus n k') -- k'을 k로 바꾸면 에러 발생
```

- 4 + 3 
- 1 + (4 + 2) 
- 1 + (1 + (4 + 1)) 
- 1 + (1 + (1 + (4 + 0))) 
- 1 + (1 + (1 + 4)) 
- 1 + (1 + 5)
- 1 + 6
- 7


Nat의 곱하기, 빼기 구현

```lean
def times (n: Nat) (k: Nat) : Nat :=
  match k with
  | Nat.zero => Nat.zero
  | Nat.succ k' => plus n (times n k')

def minus (n: Nat) (k: Nat): Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => pred (minus n k')
```

Nat의 나누기 구현
```lean
def div (n: Nat) (k: Nat): Nat :=
  if n < k then
    Nat.zero
  else
    Nat.succ (div (minus n k) k)
```

```
failed to infer structural recursion:
Not considering parameter k of div:
  it is unchanged in the recursive calls
Cannot use parameter k:
  failed to eliminate recursive application
    div (minus n k) k


failed to prove termination, possible solutions:
  - Use `have`-expressions to prove the remaining goals
  - Use `termination_by` to specify a different well-founded relation
  - Use `decreasing_by` to specify your own tactic for discharging this kind of goal
k n : Nat
h✝ : ¬n < k
⊢ minus n k < nLean 4
```

- Not considering parameter k of div: it is unchanged in the recursive calls
  - 재귀 호출을 할 때 두 번째 인자인 k가 변하지 않고 그대로 전달되었다는 뜻
- failed to eliminate recursive application
  - k가 그대로라면, 첫 번째 인자인 n이라도 확실히 줄어들어야 하는데, 그 인과관계를 논리적으로 증명하는 데 실패
- `k n : Nat`
  - 상황: k와 n은 자연수(Nat)입니다.
- `h✝ : ¬n < k`
  - h: 가정(hypothesis)입니다. -- n이 k보다 작지 않다는 것을 의미합니다.
  - ✝ (Dagger): 증명 과정에서 생성된 임시 가정이나 목표를 나타내는 표식
  - : "~은 ~이다"
  - ¬ (Negation): **부정(NOT)**
  - n < k: "n이 k보다 작다"
  -  "n이 k보다 작지 않다 (즉, n이 k보다 크거나 같다)"
    - else 절에서는 이미 n < k 조건을 만족하는 값들이 왔으므로!!
- `⊢ minus n k < n`
  - ⊢ (Turnstile): "이것이 증명되어야 한다"
  - minus n k < n: "n에서 k를 뺀 값이 n보다 작다"는 것을.
  - **"n에서 k를 뺀 결과가 원래의 n보다 작은지 증명하라"**
    - else 절에서 div (minus n k) k가 호출되는데, 이 때 minus n k가 n보다 작은지 증명해야 하는 상황이 발생
    - 이를 증명하지 못하면 동일한 div n k 가 재귀적으로 호출되는 상황이 발생하여 종료를 보장할 수 없게 됨

> This message means that div requires a manual proof of termination. This topic is explored in the final chapter.
> 
> 이 메시지는 div 함수가 종료된다는 것을 (컴파일러가 자동으로 알 수 없으므로) 사용자가 직접 증명해야 함을 의미합니다. 이 주제는 마지막 장(8.4 More Inequalities 부등식 심화)에서 자세히 다룹니다.