# Swift Testing Anti-Patterns Lab

A standalone Swift 6 package containing safe, inspectable reproductions of asynchronous unit-test
anti-patterns and their corrections. The examples are genericized and have no proprietary
application dependencies, so they can be quoted or linked from a public post.

## Requirements

- macOS 13 or newer
- Swift 6.0 or newer
- A toolchain containing the Swift Testing framework

The package was verified with Apple Swift 6.4 and Testing Library 2084.

## Run

```bash
swift test
```

Every normal test passes. Unsafe forms that would deliberately hang or crash are preserved as
source comments. Expected assertion failures use `withKnownIssue`, so those mechanisms remain
active and cannot silently rot.

## Cases

1. Escaped stream-consumer task
2. Unbounded callback/continuation wait
3. Unbounded `Task.yield()` polling
4. Swallowed cancellation executing stale work
5. Fire-and-forget task ownership
6. Cancellation-unsafe continuation gate
7. Unbounded async-iterator wait
8. Real sleep used as synchronization
9. Busy polling instead of event-driven waiting
10. `fatalError` and force-unwrap extraction
11. Non-fatal prerequisite checks
12. Aggregate scenario loops versus parameterized tests

Each case file names one anti-pattern and contains either a `BAD` source comment, an active
reproduction, or both, followed by a passing correction.

See `SHARING.md` for the license, suggested article caption, and publication checklist.
See `VERIFICATION.md` for the tested toolchain and recorded results.

## Publication Notes

- The code in this package is original, generic sample code under the MIT license.
- It models patterns observed during a private application test audit, but does not include private
  application types, business names, data, or source excerpts.
- Results from this package demonstrate language and framework mechanisms. They do not establish
  how frequently any pattern fails in CI.
- `.timeLimit(.minutes(1))` is deliberately used only as a cooperative deadline. It does not
  forcibly terminate arbitrary unstructured or non-cooperative work; the fixes still own and
  terminate their asynchronous tasks.

## Layout

```text
Sources/AntiPatternsLab/
  AsyncFixtures.swift
  CancellableGate.swift
  ExampleServices.swift

Tests/AntiPatternsLabTests/
  Case01_EscapedStreamTaskTests.swift
  ...
  Case12_ParameterizedCasesTests.swift
```
