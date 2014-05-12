// RUN: rm -rf %t
// RUN: mkdir -p %t/comments.framework/Modules/comments.swiftmodule/

// RUN: %swift -module-name comments -emit-module -emit-module-path %t/comments.framework/Modules/comments.swiftmodule/x86_64.swiftmodule -emit-module-doc-path %t/comments.framework/Modules/comments.swiftmodule/x86_64.swiftdoc %s
// RUN: %swift-ide-test -print-module-comments -module-to-print=comments -source-filename %s -F %t | FileCheck %s

// RUN: cp -r %t/comments.framework/Modules/comments.swiftmodule %t/comments.swiftmodule
// RUN: %swift-ide-test -print-module-comments -module-to-print=comments -source-filename %s -I %t | FileCheck %s

// REQUIRES: OS=macosx

/// first_decl_class_1 Aaa.
class first_decl_class_1 {

  /// decl_func_1 Aaa.
  func decl_func_1() {}

  /**
   * decl_func_3 Aaa.
   */
  func decl_func_2() {}

  /// decl_func_3 Aaa.
  /** Bbb. */
  func decl_func_3() {}
}

// CHECK: Class/first_decl_class_1 RawComment=[/// first_decl_class_1 Aaa.\n]
// CHECK: Func/first_decl_class_1.decl_func_1 RawComment=[/// decl_func_1 Aaa.\n]
// CHECK: Func/first_decl_class_1.decl_func_2 RawComment=[/**\n   * decl_func_3 Aaa.\n   */]
// CHECK: Func/first_decl_class_1.decl_func_3 RawComment=[/// decl_func_3 Aaa.\n/** Bbb. */]

