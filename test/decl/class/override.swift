// RUN: %swift -parse %s -verify -parse-as-library

class A {
  func ret_sametype() -> Int { return 0 }
  func ret_subclass() -> A { return self }
  func ret_subclass_rev() -> B { return B() }
  func ret_nonclass_optional() -> Int? { return .None }
  func ret_nonclass_optional_rev() -> Int { return 0 }
  func ret_class_optional() -> B? { return .None }
  func ret_class_optional_rev() -> A { return self }
  func ret_class_uoptional() -> B! { return B() }
  func ret_class_uoptional_rev() -> A { return self }
  func ret_class_optional_uoptional() -> B? { return .None }
  func ret_class_optional_uoptional_rev() -> A! { return self }

  func param_sametype(x : Int) {}
  func param_subclass(x : B) {}
  func param_subclass_rev(x : A) {}
  func param_nonclass_optional(x : Int) {}
  func param_nonclass_optional_rev(x : Int?) {}
  func param_class_optional(x : B) {}
  func param_class_optional_rev(x : B?) {}
  func param_class_uoptional(x : B) {}
  func param_class_uoptional_rev(x : B!) {}
  func param_class_optional_uoptional(x : B!) {}
  func param_class_optional_uoptional_rev(x : B?) {}
}

class B : A {
  override func ret_sametype() -> Int { return 1 }
  override func ret_subclass() -> B { return self }
  func ret_subclass_rev() -> A { return self }
  override func ret_nonclass_optional() -> Int { return 0 }
  func ret_nonclass_optional_rev() -> Int? { return 0 }
  override func ret_class_optional() -> B { return self }
  func ret_class_optional_rev() -> A? { return self }
  override func ret_class_uoptional() -> B { return self }
  func ret_class_uoptional_rev() -> A! { return self }
  override func ret_class_optional_uoptional() -> B! { return self }
  override func ret_class_optional_uoptional_rev() -> A? { return self }

  override func param_sametype(x : Int) {}
  override func param_subclass(x : A) {}
  func param_subclass_rev(x : B) {}
  override func param_nonclass_optional(x : Int?) {}
  func param_nonclass_optional_rev(x : Int) {}
  override func param_class_optional(x : B?) {}
  func param_class_optional_rev(x : B) {}
  override func param_class_uoptional(x : B!) {}
  func param_class_uoptional_rev(x : B) {}
  override func param_class_optional_uoptional(x : B?) {}
  override func param_class_optional_uoptional_rev(x : B!) {}
}

class C<T> {
  func ret_T() -> T {} 
}

class D<T> : C<T[]> {
  override func ret_T() -> T[] {} 
}

class E {
  var var_sametype: Int { get { return 0 } set {} }
  var var_subclass: E { get { return self } set {} } // expected-note{{attempt to override property here}}
  var var_subclass_rev: F { get { return F() } set {} } // expected-note{{attempt to override property here}}
  var var_nonclass_optional: Int? { get { return .None } set {} } // expected-note{{attempt to override property here}}
  var var_nonclass_optional_rev: Int { get { return 0 } set {} } // expected-note{{attempt to override property here}}
  var var_class_optional: F? { get { return .None } set {} } // expected-note{{attempt to override property here}}
  var var_class_optional_rev: E { get { return self } set {} } // expected-note{{attempt to override property here}}
  var var_class_uoptional: F! { get { return F() } set {} } // expected-note{{attempt to override property here}}
  var var_class_uoptional_rev: E { get { return self } set {} } // expected-note{{attempt to override property here}}
  var var_class_optional_uoptional: F? { get { return .None } set {} }
  var var_class_optional_uoptional_rev: E! { get { return self } set {} }

  var ro_sametype: Int { return 0 }
  var ro_subclass: E { return self }
  var ro_subclass_rev: F { return F() }
  var ro_nonclass_optional: Int? { return 0 }
  var ro_nonclass_optional_rev: Int { return 0 } // expected-note{{attempt to override property here}}
  var ro_class_optional: F? { return .None }
  var ro_class_optional_rev: E { return self } // expected-note{{attempt to override property here}}
  var ro_class_uoptional: F! { return F() }
  var ro_class_uoptional_rev: E { return self } // expected-note{{attempt to override property here}}
  var ro_class_optional_uoptional: F? { return .None }
  var ro_class_optional_uoptional_rev: E! { return self }
}

class F : E {
  override var var_sametype: Int { get { return 0 } set {} }
  override var var_subclass: F { get { return self } set {} } // expected-error{{cannot override mutable property 'var_subclass' of type 'E' with covariant type 'F'}}
  override var var_subclass_rev: E { get { return F() } set {} } // expected-error{{property 'var_subclass_rev' with type 'E' cannot override a property with type 'F}}
  override var var_nonclass_optional: Int { get { return 0 } set {} } // expected-error{{cannot override mutable property 'var_nonclass_optional' of type 'Int?' with covariant type 'Int'}}
  override var var_nonclass_optional_rev: Int? { get { return 0 } set {} } // expected-error{{property 'var_nonclass_optional_rev' with type 'Int?' cannot override a property with type 'Int'}}
  override var var_class_optional: F { get { return self } set {} } // expected-error{{cannot override mutable property 'var_class_optional' of type 'F?' with covariant type 'F'}}
  override var var_class_optional_rev: E? { get { return self } set {} } // expected-error{{property 'var_class_optional_rev' with type 'E?' cannot override a property with type 'E'}}
  override var var_class_uoptional: F { get { return F() } set {} } // expected-error{{cannot override mutable property 'var_class_uoptional' of type 'F!' with covariant type 'F'}}
  override var var_class_uoptional_rev: E! { get { return self }  set {} } // expected-error{{property 'var_class_uoptional_rev' with type 'E!' cannot override a property with type 'E'}}
  override var var_class_optional_uoptional: F! { get { return .None } set {} }
  override var var_class_optional_uoptional_rev: E? { get { return self } set {} }

  override var ro_sametype: Int { return 0 }
  override var ro_subclass: E { return self }
  override var ro_subclass_rev: F { return F() }
  override var ro_nonclass_optional: Int { return 0 }
  override var ro_nonclass_optional_rev: Int? { return 0 } // expected-error{{property 'ro_nonclass_optional_rev' with type 'Int?' cannot override a property with type 'Int'}}
  override var ro_class_optional: F { return self }
  override var ro_class_optional_rev: E? { return self } // expected-error{{property 'ro_class_optional_rev' with type 'E?' cannot override a property with type 'E'}}
  override var ro_class_uoptional: F { return F() }
  override var ro_class_uoptional_rev: E! { return self } // expected-error{{property 'ro_class_uoptional_rev' with type 'E!' cannot override a property with type 'E'}}
  override var ro_class_optional_uoptional: F! { return .None }
  override var ro_class_optional_uoptional_rev: E? { return self }
}


class G {
  func f1(Int, int: Int) { }
  func f2(Int, int: Int) { }
  func f3(Int, int: Int) { }
  func f4(Int, int: Int) { }
  func f5(Int, int: Int) { }
  func f6(Int, int: Int) { }
  func f7(Int, int: Int) { }

  func g1(Int, string: String) { } // expected-note{{potential overridden method 'g1(_:string:)' here}}
  func g1(Int, path: String) { } // expected-note{{potential overridden method 'g1(_:path:)' here}}
}

class H : G {
  override func f1(Int, Int) { } // expected-error{{argument names for method 'f1' do not match those of overridden method 'f1(_:int:)'}}{{25-25=int: }}
  override func f2(Int, value: Int) { } // expected-error{{argument names for method 'f2(_:value:)' do not match those of overridden method 'f2(_:int:)'}}{{25-25=int }}
  override func f3(Int, value int: Int) { } // expected-error{{argument names for method 'f3(_:value:)' do not match those of overridden method 'f3(_:int:)'}}{{25-31=}}
  override func f4(Int, _ int: Int) { } // expected-error{{argument names for method 'f4' do not match those of overridden method 'f4(_:int:)'}}{{25-27=}}
  override func f5(Int, value inValue: Int) { } // expected-error{{argument names for method 'f5(_:value:)' do not match those of overridden method 'f5(_:int:)'}}{{25-30=int}}
  override func f6(Int, _ inValue: Int) { } // expected-error{{argument names for method 'f6' do not match those of overridden method 'f6(_:int:)'}}{{25-26=int}}

  override func f7(Int, int value: Int) { } // okay

  override func g1(Int, s: String) { } // expected-error{{declaration 'g1(_:s:)' has different argument names from any potential overrides}}
}
