
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
