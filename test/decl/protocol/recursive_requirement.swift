// RUN: %swift -parse %s -verify

protocol Foo {
  typealias Bar : Foo // expected-note {{protocol requires nested type 'Bar'}}
}

struct Oroborous : Foo { // expected-error {{type 'Oroborous' does not conform to protocol 'Foo'}}
  typealias Bar = Oroborous // expected-note {{possibly intended match 'Bar' does not conform to 'Foo'}}
}
