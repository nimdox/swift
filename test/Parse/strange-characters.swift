// RUN: %swift %s -parse -verify

// The next three lines contain NUL characters; please don't remove!
// " " expected-warning{{nul character}} {{5-6=}}
/* " " expected-warning{{nul character}} {{5-6=}} */
var someChar = 1 // expected-warning{{nul character}} {{15-16=}}
