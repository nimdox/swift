//===--- NSSwiftArray.swift - Links NSArray and NativeArrayStorage --------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
//  NSSwiftArray supplies the implementation of the CocoaArray API
//  (and thus, NSArray the API) for our NativeArrayStorage<T>.  We
//  can't put this implementation directly on NativeArrayStorage
//  because generic classes can't override Objective-C selectors.
//
//===----------------------------------------------------------------------===//

import SwiftShims

// Base class of the heap buffer implementation backing the new Array
// design.  
@objc
class NSSwiftArray : HeapBufferStorageBase, CocoaArray {
  typealias Buffer = HeapBuffer<_ArrayBody, AnyObject>
  
  var dynamicElementType: Any.Type {
    fatal("This var must be overridden")
  }
  
  /// Returns the object located at the specified index.
  func objectAtIndex(index: Int) -> AnyObject {
    let buffer = reinterpretCast(self) as Buffer
    // If used as an NSArray, the element type can have no fancy
    // bridging; just get it and return it
    assert(buffer.value.elementTypeIsBridgedVerbatim)
    return buffer[index]
  }

  // Copies the objects contained in the array that fall within the
  // specified range to aBuffer.
  func getObjects(aBuffer: UnsafePointer<AnyObject>, range: _SwiftNSRange) {

    // These objects are "returned" at +0, so treat them as values to
    // avoid retains.
    var dst = UnsafePointer<Word>(aBuffer)

    let buffer = reinterpretCast(self) as Buffer
    // If used as an NSArray, the element type can have no fancy
    // bridging; just get it and return it
    assert(buffer.value.elementTypeIsBridgedVerbatim)
    
    if _fastPath(buffer.value.elementTypeIsBridgedVerbatim) {
      dst.initializeFrom(
        UnsafePointer(buffer.elementStorage + range.location),
        count: range.length)
    }
    
    for i in range.location...range.location + range.length {
      dst++.initialize(reinterpretCast(buffer[i]))
    }
  }

  func copyWithZone(_: COpaquePointer) -> CocoaArray {
    return self
  }

  func countByEnumeratingWithState(
    state: UnsafePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafePointer<AnyObject>, count bufferSize: Int
  ) -> Int {
    var enumerationState = state.get()

    let buffer = reinterpretCast(self) as Buffer
    // If used as an NSArray, the element type can have no fancy
    // bridging; just get it and return it
    assert(buffer.value.elementTypeIsBridgedVerbatim)
    
    if enumerationState.state != 0 {
      return 0
    }
    enumerationState.mutationsPtr = _fastEnumerationStorageMutationsPtr
    enumerationState.itemsPtr = reinterpretCast(buffer.elementStorage)
    enumerationState.state = 1
    state.set(enumerationState)
    return buffer.value.count
  }
  
  var count: Int {
    return (reinterpretCast(self) as Buffer).value.count
  }
}
