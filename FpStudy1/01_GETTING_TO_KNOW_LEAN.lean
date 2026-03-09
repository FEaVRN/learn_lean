
-- # 01_GETTING_TO_KNOW_LEAN

-- ## 1.1 Evaluating Expressions

#eval 1 + 2
#eval 1 + 2 * 5

#eval String.append("Hello, ", "Lean!")
#eval String.append "Hello, " "Lean!"


#eval String.append "great " String.append "oak " "tree"
#eval String.append "great " (String.append "oak " "tree")


#eval String.append "it is " (if 1 > 2 then "yes" else "no")

#eval String.append "it is "

#eval 42 + 19
#eval String.append "A" (String.append "B" "C")
#eval String.append (String.append "A" "B") "C"
#eval if 3 == 3 then 5 else 7
#eval if 3 == 4 then "equal" else "not equal"


-- ## 1.2 Types

#eval (1 + 2: Nat)

#eval (1 - 2: Nat)
#eval (1 - 2: Int)

#check (1 - 2: Nat)
#check (1 - 2: Int)

#check String.append "hello"

-- ## 1.3 Functions and Definitions

-- ### 1.3.1 Defining Functions

#check 2 + 2 = 4
#check 2 + 2 == 4

def hello := "Hello"
def lean: String := "Lean"
#eval String.append hello (String.append ", " lean)


def add1 (n: Nat) : Nat := n + 1
#eval add1 7

def maximum (n: Nat) (k: Nat): Nat :=
  if n < k then k
           else n

def spaceBetween (before: String) (after: String) : String :=
  String.append before (String.append " " after)

#check add1
#check (add1)

#check maximum 3
#check maximum 3 4
#check (maximum 3) 4


def joinStringsWith (seperator: String) (s1: String) (s2: String) : String :=
  String.append s1 (String.append seperator s2)

#eval joinStringsWith ", " "one" "and another"

#check joinStringsWith ": "

def volumeOfRectangularPrism (height: Nat) (width: Nat) (depth: Nat): Nat :=
  height * width * depth

#eval volumeOfRectangularPrism 2 3 4

-- ### 1.3.2 Defining Types

def Str: Type := String
def aStr: Str := "This is a string"
#eval aStr


def NaturalNumber: Type := Nat
def thirtyEight: NaturalNumber := 38

def thirtyEight2: NaturalNumber := (38: Nat)

abbrev N: Type := Nat
def fortyTwo: N := 42


-- ## 1.4 Structures

#check 1.2

#check -454.21232145

#check 0.0

#check 0

structure Point where
  x: Float
  y: Float

def origin : Point := { x:= 0.0, y:= 0.0 }
def origin2 := ({ x := 0.0, y := 0.0 } : Point)
def origin3 := {x := 0.0, y:= 0.0 : Point}

#eval origin
#check origin

def origin1 := { x:= 0.0, y:= 0.0 } -- error

#eval Point.x origin
#eval origin.x

#eval Point.y origin
#eval origin.y


def addPoints (p1 : Point) (p2 : Point) : Point :=
  { x := p1.x + p2.x, y := p1.y + p2.y }

#eval addPoints { x := 1.5, y := 32 } { x := -8, y := 0.2 }


-- ### 1.4.1 Updating Structures

def zeroX (p: Point) : Point :=
  { p with x := 0.0 }

def fourAndThree : Point :=
  { x := 4.3, y := 3.4 }

#eval fourAndThree
#eval zeroX fourAndThree
#eval fourAndThree

-- ### 1.4.2 Behind the Scenes


-- check functions in namespace
#check Point

structure Point2 where
  point ::
  x: Float
  y: Float

#eval {x := 0.0, y := 0.0 : Point2}
#eval Point2.point 0.0 0.0

#eval "Hello, ".append "world!"

def Point.modifyBoth (f: Float → Float) (p: Point) : Point :=
  { x := f p.x, y := f p.y }

#eval fourAndThree.modifyBoth Float.floor


--- ### 1.4.3 Exercises

structure RectangularPrism where
  height: Float
  width: Float
  depth: Float

def RectangularPrism.volume (rp: RectangularPrism) : Float :=
  rp.height * rp.width * rp.depth


structure Segment where
  p1: Point
  p2: Point

def Segment.length (s: Segment) : Float :=
  let dx := s.p2.x - s.p1.x
  let dy := s.p2.y - s.p1.y
  Float.sqrt (dx * dx + dy * dy)

structure Hamster where
  name : String
  fluffy : Bool
structure Book where
  makeBook ::
  title : String
  author : String
  price : Float

#check Hamster.mk
#check Hamster.name
#check Hamster.fluffy

#check Book.makeBook
#check Book.title
#check Book.author
#check Book.price

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
