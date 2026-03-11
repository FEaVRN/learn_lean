-- ## 1.6 Polymorphism

#check List Nat
#check List String
#check List (List Nat)

#check Option String

structure PPoint (α: Type) where
  x: α
  y: α

def natOrigin: PPoint Nat := { x := Nat.zero, y := Nat.zero }

-- def errNatOrigin: PPoint Nat := { x := Nat.zero, y := 0.0 }

def replaceX (α: Type) (p: PPoint α) (newX: α): PPoint α :=
  { p with x := newX }

#check replaceX -- (α : Type) → PPoint α → α → PPoint α
#check replaceX Nat -- PPoint Nat -> Nat -> PPoint Nat

#eval replaceX natOrigin 5 -- error

#check replaceX Nat natOrigin -- Nat -> PPoint Nat
#check replaceX Nat natOrigin 5 -- PPoint Nat
#eval replaceX Nat natOrigin 5 -- { x:= 5, y:= 0 : PPoint Nat }

inductive Sign where
  | pos
  | neg

def posOrNegThree (s : Sign):
  match s with
  | Sign.pos => Nat
  | Sign.neg => Int :=
  match s with
  | Sign.pos => 3
  | Sign.neg => -3

-- ### 1.6.1 Linked List 연결 리스트

def primesUnder10: List Nat := [2, 3, 5, 7]

inductive MyList (α : Type) where
  | nil : MyList α
  | cons : α → MyList α → MyList α

def explicitPrimesUnder10: List Nat :=
  List.cons 2 (List.cons 3 (List.cons 5 (List.cons 7 List.nil)))

def nats := 4::5::3::[]
#eval nats


def length (α: Type) (xs: List α): Nat :=
  match xs with
  | List.nil => 0
  | List.cons y ys => 1 + length α ys -- Nat.succ (length α ys)

#eval length String ["Sourdough", "Bread"]

def length2 (α: Type) (xs: List α): Nat :=
  match xs with
  | [] => 0
  | y::ys => 1 + length2 α ys

-- ## 1.6.2 Implicit Arguments

def length3 {α: Type} (xs: List α): Nat :=
  match xs with
  | [] => 0
  | y::ys => 1 + length3 ys

#eval length3 String ["Sourdough", "Bread"] --error
#eval length3 (α := String) ["Sourdough", "Bread"] -- 2
#eval length3 ["Sourdough", "Bread"] -- 2

#check List.length (α := String) -- List String -> Nat

-- ### 1.6.3 More Built-In Datatypes

-- #### Option

#check Option Nat
#check Option String
#check Option (List Nat)

inductive MyOption (α: Type) where
  | none: MyOption α
  | some: α → MyOption α

def List.myhead? {α: Type} (xs: List α): Option α :=
  match xs with
  | [] => Option.none
  | y::_ => Option.some y

#check List.head!
#check List.head?
#check List.headD

#eval List.headD [] "No bread"

#eval primesUnder10.head?

#eval [].head?

#eval [].head? ( α := Nat ) -- implicit argument 명시
#eval ([]: List Nat).head? -- List 타입을 explicit하게 명시

-- #### Prod

structure MyProd (α: Type) (β: Type) where
  fst: α
  snd: β

def pair := (4,5)
#check pair
def pair2 := Prod.mk 6 7
#check pair2

-- \x 라고 쓰면 입력됨

def fives: String × Int := {
  fst := "Five"
  snd := 5
}
#check fives

def fives' : String × Int := ("Five", 5)
#check fives'

def sevens: String × Int × Nat := ("VII", 7, 4 + 3)
def sevens' : String × Int × Nat := ("VII", (7, 4 + 3))

-- #### Sum

inductive MySum (α: Type) (β: Type) where
  | inl: α -> MySum α β
  | inr: β -> MySum α β

def leftValue : Sum String Int := Sum.inl "Hello"
def rightValue : Sum String Int := Sum.inr 42

def checkSum (s : Sum String Int) : String :=
  match s with
  | Sum.inl s => "문자열이 들어있네요: " ++ s
  | Sum.inr n => "숫자가 들어있네요: " ++ toString n

#eval checkSum leftValue   -- "문자열이 들어있네요: Hello"
#eval checkSum rightValue  -- "숫자가 들어있네요: 42"

-- \oplus \o+ 라고 입력

def PetName : Type := String ⊕ String
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

-- #### Unit

inductive MyUnit where
  | unit

-- #### Empty

inductive MyEmpty where
  -- 생성자가 없음


-- ### 1.6.4 Messages You May Meet

inductive MyType: Type where
  | ctor: (α: Type) -> α -> MyType

inductive MyType (α: Type) where
  | ctor: (a: α) -> MyType α

inductive MyType2 : Type where
  | ctor : (MyType2 -> Int) -> MyType2


-- {α: Type} {β: Type} 안써도 알아서 컴파일러가 implicit argument로 인식해서 처리해줌
def sameLength (xs: List α) (ys: List β): Bool :=
  match (xs, ys) with
  | ([], []) => true
  | (x::xs', y::ys') => sameLength xs' ys'
  | _ => false

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

#check sameLength2
#eval sameLength2 [1, 2, 3] ["a", "b", "c"]


#check List.head ([]: List Nat)


inductive MyType3 (α: Type) : Type where
  | ctor : α -> MyType3


inductive MyType4 (α: Type) : Type where
  | ctor : α -> MyType4 α

def ofFive: MyType4 := MyType4.ctor 5

def ofFive2 := MyType4.ctor 5 --ok
def ofFive3 : MyType4 Nat := MyType4.ctor 5 --ok


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

#eval allTools

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

-- ### 1.6.5 Exercises

def last {α: Type} (xs: List α): Option α :=
   match xs with
   | [] => Option.none
   | x::[] => Option.some x
   | _::xs' => last xs'

#eval last [1, 2, 3] -- Option.some 3
#eval last ([] : List Nat) -- Option.none

def List.findFirst? {α: Type} (xs: List α) (predicate: α -> Bool) : Option α :=
  match xs with
  | [] => Option.none
  | x::xs' => if predicate x then Option.some x else List.findFirst? xs' predicate

#eval List.findFirst? [1, 2, 3, 4] (fun x => x % 2 == 0) -- Option.some 2
#eval List.findFirst? [1, 3, 5] (fun x => x % 2 == 0) -- Option.none

def Prod.switch {α: Type} {β: Type} (pair: α × β): β × α :=
  match pair with
  | (a, b) => (b, a)

inductive PetNameInductive
  | dog (name: String): PetNameInductive
  | cat: String -> PetNameInductive

#eval PetNameInductive.dog "hi"
#eval PetNameInductive.cat "nyooo"

def zip {α: Type} {β: Type} (xs: List α) (ys: List β) : List (α × β) :=
  match xs with
  | [] => []
  | x::xs' =>
    match ys with
    | [] => []
    | y::ys' => (x, y)::(zip xs' ys')

#eval zip [1, 2, 3] ["a", "b", "c"] -- [(1, "a"), (2, "b"), (3, "c")]
#eval zip [1, 2] ["a", "b", "c"] --

def take {α: Type} (n: Nat) (xs: List α) : List α :=
  if n == 0
  then []
  else
    match xs with
    | [] => []
    | x::xs' => x::(take (n - 1) xs')

#eval take 3 ["bolete", "oyster"]
#eval take 1 ["bolete", "oyster"]


def distributeProductsOverSums (p: α × (β ⊕ γ)) : (α × β) ⊕ (α × γ) :=
  match p with
  | (a, Sum.inl left) => Sum.inl (a, left)
  | (a, Sum.inr right) => Sum.inr (a, right)

#eval distributeProductsOverSums (4, (Sum.inl "hello" : Sum String Int)) -- Sum.inl (4, "hello")
#eval distributeProductsOverSums (4, (Sum.inr true : Sum String Bool)) -- Sum.inr

def multiplicationByTwoIntoSum (p: Bool × α) : α ⊕ α :=
  match p with
  | (true, a) => Sum.inl a
  | (false, a) => Sum.inr a

#eval multiplicationByTwoIntoSum (true, 5) -- Sum.inl 5
#eval multiplicationByTwoIntoSum (false, "hello") -- Sum.inr "hello
