// RUN: %swift -target x86_64-apple-darwin10 %s -emit-ir -parse-as-library

// Smoke test that SIL-IRGen can compile a library module offline.
func f() {}
