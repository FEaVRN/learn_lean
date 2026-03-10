-- ## 1.5 Datatypes and Patterns

inductive User where
  | owner
  | editor
  | viewer

inductive Operator where
  | addition
  | subtraction
  | multiplication
  | division

inductive MyList (α: Type) where
  | nil: MyList α
  | cons: α -> MyList α -> MyList α

def xs : MyList Nat :=
  MyList.cons 1 (MyList.cons 2 (MyList.cons 3 MyList.nil))


inductive MyBool where
  | false : MyBool
  | true : MyBool

#eval Bool.true
#eval Bool.false


inductive MyNat where
  | zero : MyNat
  | succ (n: MyNat): MyNat -- 인자를 받는다.

#eval Nat.zero
#eval Nat.succ Nat.zero = 1
#eval Nat.succ (Nat.succ Nat.zero) == 2
#eval Nat.succ (Nat.succ (Nat.succ Nat.zero)) == 3

-- ### 1.5.1 Pattern Matching

def isZero (n: Nat): Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ _ => false -- `_`는 와일드카드 패턴으로, 어떤 값이든 상관없음을 나타냄


def pred (n: Nat): Nat :=
  match n with
  | Nat.zero => Nat.zero
  | Nat.succ m => m

#eval pred 5
#eval pred (Nat.succ 4)

structure Point3D where
  x: Float
  y: Float
  z: Float

def depth (p: Point3D): Float :=
  match p with
  | { x:= _, y:= _, z:= d } => d

-- ### 1.5.2 Recursive Functions

def even (n: Nat): Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ m => not (even m)


def evenLoop (n: Nat): Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ m => not (evenLoop n) -- 무한 루프에 빠짐

def plus (n: Nat) (k: Nat): Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => Nat.succ (plus n k')

def times (n: Nat) (k: Nat) : Nat :=
  match k with
  | Nat.zero => Nat.zero
  | Nat.succ k' => plus n (times n k')

def minus (n: Nat) (k: Nat): Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => pred (minus n k')

def div (n: Nat) (k: Nat): Nat :=
  if n < k then
    Nat.zero
  else
    Nat.succ (div (minus n k) k)
