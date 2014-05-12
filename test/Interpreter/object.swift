// RUN: %target-run-simple-swift | FileCheck %s

func test() {
  var d1 = Dictionary<String, Int>()
  var d2 = Dictionary<String, Int>()
  var d1_alias = d1
//  Dictionary is no longer a class type
//  if d1 !== d2 {
    println("good")
//  }
//  if d1 === d1_alias {
    println("also good")
//  }
}

test()

// CHECK: good
// CHECK: also good
