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

-- TODO
