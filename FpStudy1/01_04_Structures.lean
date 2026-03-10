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
