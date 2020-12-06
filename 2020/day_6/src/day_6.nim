import strutils, sequtils, sets

let input = string(readFile("input.txt")).split("\n\n")

var sum  = 0
var sum2 = 0

for camp in input:
  sum += camp.deduplicate().filterIt(it != '\n').len()
  let people = camp.splitLines()
  var sp = people[0].toHashSet()
  for p in people:
      sp = sp.intersection(p.toHashSet())
  sum2 += sp.len()

when isMainModule:
  echo sum
  echo sum2 
