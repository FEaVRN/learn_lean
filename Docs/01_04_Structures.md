
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

