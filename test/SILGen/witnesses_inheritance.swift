// RUN: %swift -emit-silgen %s | FileCheck %s

protocol Fooable {
  func foo()
  class func class_foo()
}

protocol Barrable : Fooable {
  func bar()
  class func class_bar()
}

class X : Fooable {
  func foo() {}
  class func class_foo() {}
}

// -- Derived class conforms to a refined protocol
class Y : X, Barrable {
  func bar() {}
  // CHECK-LABEL: sil @_TTWC21witnesses_inheritance1YS_7FooableFS1_3fooUS1___fRQPS1_FT_T_
  // CHECK:         upcast {{%.*}} : $Y to $X
  class func class_bar() {}
  // CHECK-LABEL: sil @_TTWC21witnesses_inheritance1YS_7FooableFS1_9class_fooUS1___fMQPS1_FT_T_
  // CHECK:         upcast {{%.*}} : $@thick Y.Type to $@thick X.Type
}

class A : Fooable {
  func foo() {}
  func bar() {}
  class func class_foo() {}
  class func class_bar() {}
}

// -- Derived class conforms to a refined protocol using its base's methods
class B : A, Barrable {}
// CHECK-LABEL: sil @_TTWC21witnesses_inheritance1BS_7FooableFS1_3fooUS1___fRQPS1_FT_T_
// CHECK:         upcast {{%.*}} : $B to $A
// CHECK-LABEL: sil @_TTWC21witnesses_inheritance1BS_7FooableFS1_9class_fooUS1___fMQPS1_FT_T_
// CHECK:         upcast {{%.*}} : $@thick B.Type to $@thick A.Type
// CHECK-LABEL: sil @_TTWC21witnesses_inheritance1BS_8BarrableFS1_3barUS1___fRQPS1_FT_T_
// CHECK:         upcast {{%.*}} : $B to $A
// CHECK-LABEL: sil @_TTWC21witnesses_inheritance1BS_8BarrableFS1_9class_barUS1___fMQPS1_FT_T_
// CHECK:         upcast {{%.*}} : $@thick B.Type to $@thick A.Type
