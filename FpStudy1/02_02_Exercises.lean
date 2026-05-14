def main : IO Unit := do
  let englishGreeting := IO.println "Hello, world!"
  IO.println "Bonjour!"
  englishGreeting

-- lean --run FpStudy1/02_02_Exercises.lean
