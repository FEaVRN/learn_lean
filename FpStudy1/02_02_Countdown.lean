def countdown : Nat → List (IO Unit)
  | 0 => [IO.println "Blast off!"]
  | n + 1 => IO.println s!"{n + 1}" :: countdown n

def from5 : List (IO Unit) := countdown 5

#eval from5.length

def runActions : List (IO Unit) → IO Unit
  | [] => pure ()
  | act :: actions => do
      act
      runActions actions

#eval runActions from5


def main: IO Unit := runActions from5

-- lean --run FpStudy1/02_02_Countdown.lean


-- 1. main
-- 2. runActions from5
-- 3. runActions (countdown 5)
-- 4. runActions [IO.println "5", IO.println "4", IO.println "3", IO.println "2", IO.println "1", IO.println "Blast off!"]
-- 5. do
--      IO.println "5"
--      IO.println "4"
--      IO.println "3"
--      IO.println "2"
--      IO.println "1"
--      IO.println "Blast off!"
--      pure ()
