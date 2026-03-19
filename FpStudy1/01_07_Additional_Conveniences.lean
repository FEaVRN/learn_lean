-- ## 1.7 Additional Conveniences

-- ## 1.7.1 Automatic Implicit Parameters

def length {α: Type} (xs: List α): Nat :=
  match xs with
  | [] => 0
  | y::ys => 1 + length ys
#check length

def length' (xs: List α): Nat :=
  match xs with
  | [] => 0
  | y::ys => 1 + length' ys

#check length'

-- ### 1.7.2 Pattern-Matching Definitions

def length'' : (xs: List α) -> Nat
  | [] => 0
  | y::ys => 1 + length'' ys

#check length''

def drop : Nat -> List α -> List α
  | Nat.zero, xs => xs
  | _, [] => []
  | Nat.succ n, x::xs => drop n xs

#check drop

def fromOption (default: α): Option α -> α
  | none => default
  | some x => x

#check fromOption
#eval fromOption (some 5) (default := 0)

#eval (none).getD 0

def confuseFn (x: String) (y: String) (z: String)
  | 0, _ => x
  | _, 0 => y
  | _, _ => z

#check confuseFn

#check confuseFn "left" "right" "neither"
#eval confuseFn "left" "right" "neither" 5 5

def confuseFn' (x: String) (y: String) (z: String) (n1: Nat) (n2: Nat): String :=
  match n1, n2 with
  | 0, _ => x
  | _, 0 => y
  | _, _ => z


-- ## 1.7.3 Local Definitions 지역 정의

def unzip: List (α × β) -> List α × List β
  | [] => ([], [])
  | (x, y) :: xys => (x :: Prod.fst (unzip xys), y :: Prod.snd (unzip xys))

def unzip': List (α × β) -> List α × List β
  | [] => ([], [])
  | (x, y) :: xys =>
    let unzipped := unzip' xys
    (x :: unzipped.fst, y :: unzipped.snd)

def unzip'': List (α × β) -> List α × List β
  | [] => ([], [])
  | (x, y) :: xys =>
    let (xs, ys) := unzip'' xys
    (x :: xs, y :: ys)

def useLets (_: Unit): Nat :=
  let a := 1
  let b := 2
  let (c, d) := (4, 5)
  -- let e, f := (6, 7) error
  let g := 8; let h := 9
  a + b + c + d + g + h

#eval useLets ()

def reverse (xs: List α): List α :=
  let rec helper: List α -> List α -> List α
    | [], acc => acc
    | y::ys, acc => helper ys (y::acc)

  helper xs []

--### 1.7.4 Type Inference

def unzip'''(pairs: List (α × β)) :=
  match pairs with
  | [] => ([], [])
  | (x, y) :: xys => (x :: (unzip''' xys).fst , y :: (unzip''' xys).snd)



#check 14

#check (14: Int)

def unzipFail pairs :=
  match pairs with
  | [] => ([], [])
  | (x,y) ::xys =>
    let unzipped := unzipFail xys
    (x:: unzipped.fst, y :: unzipped.snd)

def id' (x: α): α := x
def id'' (x: α) := x -- remove return type annotation
def id''' x := x -- error Failed to infer type of definition `id'''`


-- ### 1.7.5 Simultaneous Matching

def drop' (n: Nat) (xs: List α) : List α :=
  match n, xs with
  | 0, _ => xs
  | _, [] => []
  | Nat.succ n', x::xs' => drop n' xs'


def drop'' (n: Nat) (xs: List α) : List α :=
  match (n, xs) with
  | (0, _) => xs
  | (_, []) => []
  | (Nat.succ n', x::xs') => drop'' n' xs'

def sameLength:  List α -> List β -> Bool
  | [], [] => true
  | _::xs, _::ys => sameLength xs ys
  | _, _ => false

-- ### 1.7.6 Natural Number Patterns

def isEven: Nat -> Bool
  | 0 => true
  | n + 1 =>  isEven n |> not

def halve : Nat -> Nat
  | 0 => 0
  | 1 => 0
  -- | Nat.succ (Nat.succ n) => 1 + halve n -- 동일
  -- | 2 + n => 1 + halve n -- error
  | n + 2 => 1 + halve n


-- ### 1.7.7 Anonymous Function

#check fun x => x + 1
#check fun (x: Int) => x
#check fun {α: Type} (x: α) => x


def result :=
  [1,2,3]
  |> List.map (fun x => x + 1)
  |> List.filter (fun x => x % 2 == 0)

#eval result

#check λ x => x + 1

#check fun
  | 0 => none
  | n + 1 => some n

def a :=
  fun x =>
    match x with
    | 0 => none
    | Nat.succ n => some n

def double : Nat -> Nat := fun
    | 0 => 0
    | n + 1 => 2 + double n

def result' :=
  [1,2,3]
  |> List.map (· + 1)
  |> List.filter (· % 2 == 0)

def what: Nat -> Nat -> Nat -> Nat := (· + · * ·)
def what': Nat -> Nat -> Nat -> Nat := ((· + ·) * ·) -- error

#eval what 1 2 3
#eval what 100 3 4
#eval what 1 100000 0

#eval (· + ·) 4 3
#eval (4 + ·) 3
#eval (· + 3) 4

-- ### 1.7.8 Namespaces

namespace NewNamespace

def triple(x: Nat): Nat := 3 * x
def quadruple(x: Nat): Nat := 4 * x

end NewNamespace

#check triple
#check NewNamespace.triple

-- open NewNamespace
-- #check triple

def timesTwelve(x: Nat): Nat :=
  open NewNamespace in

  let a := x
  |> quadruple
  |> triple

  let b := 3

  let c := quadruple 3
  a

#eval timesTwelve 5


open NewNamespace in
#eval triple 5

#eval triple 5


-- ### 1.7.9 if let

inductive Inline where
  | lineBreak
  | string: String ->  Inline
  | emph: Inline -> Inline
  | strong : Inline -> Inline

def Inline.string? : Inline -> Option String
  | Inline.string s => some s
  | _ => none


def Inline.string?' (inline: Inline): Option String :=
  if let Inline.string s := inline then
    some s
  else
    none

-- ### 1.7.10 Positional Structure Arguments

structure Point3D where
  x: Nat
  y: Nat
  z: Nat

def allZero := Point3D.mk 0 0 0
#eval allZero

def allZero': Point3D := { x := 0, y := 0, z := 0 }
#eval allZero'

#eval ⟨0, 0, 0⟩
#eval (⟨0, 0, 0⟩: Point3D)

def deconstructPoint3D (p: Point3D): Nat :=
  let ⟨x1, y1, z1⟩ := p
  let { y := y2, x := x2, z := z2} := p
  x1 + y2 + z1

def add1Point3D (p : Point3D): Point3D :=
  ⟨p.x + 1, p.y + 1, p.z + 1⟩


-- ### 1.7.11 String Interpolation

#eval s!"Hello {1 + 2} world {String.length "abcd"}"

#eval s!"My Func: {NewNamespace.triple}"
