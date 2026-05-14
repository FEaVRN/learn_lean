-- lean --run FpStudy1/02_02_HelloName.lean

def main: IO Unit := do
  let stdin <- IO.getStdin
  let stdout <- IO.getStdout

  stdout.putStrLn "How would you like to be addressed?"
  let input ← stdin.getLine
  let name := input.dropEndWhile Char.isWhitespace
  stdout.putStrLn s!"Hello, {name}!"

def twice (action : IO Unit) : IO Unit := do
  action
  action

def nTimes (action : IO Unit) : Nat → IO Unit
  | 0 => pure ()
  | n + 1 => do
      action
      nTimes action n

#eval nTimes (IO.println "Hello") 3
