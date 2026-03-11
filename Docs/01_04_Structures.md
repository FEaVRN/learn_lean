[Formalizing a proof in Lean using Claude Code : 클로드 코드를 이용한 증명 형식화](https://www.youtube.com/watch?v=JHEO7cplfk8)

[영상 코드 GitHub 링크](https://github.com/teorth/analysis/blob/main/analysis/Analysis/Misc/equational.lean)

[Equational Theories 프로젝트 GitHub 링크](https://teorth.github.io/equational_theories/)



2006년에 필즈상을 수상한 테렌스 타오가 Claude Code AI 에이전트를 사용하여 Lean 프로그래밍 언어로 수학 증명을 형식화하는 과정

형식화: 정리증명기(Lean)가 검증 가능한 논리식으로 변환

'등식 이론(Equational Theories)' 프로젝트 내에 있는 특정 명제인 '식 1689(Equation 1689)'가 '식 2(Equation 2)'를 함의한다는 것을 증명하려고 했습니다 (0:30-0:36).

만약 어떤 구조에서 식1689가 참이라면 반드시 식2 (x = y)도 참인가?

- Equation 2: x = y
- Equation 1689: x = (y ⋄ x) ⋄ ((x ⋄ z) ⋄ z)

이 명제는 **'싱글톤 법칙(singleton law)'** 이라고도 불리며, 사람이 제공한 비공식 증명을 Claude Code AI 에이전트를 사용하여 Lean 프로그래밍 언어로 **형식화(formalize)** 하는 것이 목표

주요 내용 요약:

- **단계별 접근**: AI가 한 번에 전체 코드를 작성하다가 실패했던 경험을 바탕으로, 증명을 **여러 렘마(Lemma)** 로 나누어 단계적으로 형식화하도록 지시합니다. (1:31 - 2:12)
- **AI 에이전트 활용**: AI에게 **정의(definitions)** 와 **골격(skeleton)** 을 먼저 작성하게 하고, 세부 증명은 사람이 수동으로 수정하거나 AI에게 다시 맡기는 식으로 협업합니다. (3:52 - 5:58)
- **문제 해결 및 병렬 작업**: AI가 형식화 과정에서 오류를 내거나 너무 복잡한 증명을 작성할 때, 사람이 수동으로 **수정(fix)** 하거나 **간소화(streamline)** 합니다. AI가 한 작업을 수행하는 동안 다른 부분을 사람이 작업하는 병렬적인 접근 방식을 보여줍니다. (13:30 - 15:58, 20:33 - 21:00)
- **결과**: 약 30분 만에 컴퓨터 멈춤 현상(crash)을 포함하여 성공적으로 증명을 완료했습니다. (26:00 - 26:25)
- **최종 코드**: 영상 설명란에 링크된 GitHub 저장소에서 확인할 수 있습니다.

재밌는 점

- 클로드 코드 토큰 다 써버려서 중간에 실패
- 작업하다가 컴퓨터 꺼짐


## 1.4 Structures

**구조체(structure)**

- 여러 개의 독립적인 데이터를 하나의 새로운 타입으로 묶는 방법
- 여러 값을 하나의 의미 있는 단위로 결합
- 여러 값을 하나의 타입으로 묶는 타입을 **product type**

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

