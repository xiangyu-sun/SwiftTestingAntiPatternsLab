# Verification

Verified on 13 October 2026.

## Environment

- Apple Swift 6.4 (`swiftlang-6.4.0.34.1`)
- Testing Library 2084
- Xcode 27.1 build 27A9275
- macOS 27.0.1
- arm64

## Results

```text
swift test
Test run with 21 tests in 12 suites passed with 2 known issues.
```

The known issues are intentional, active demonstrations:

- `#expect` records an issue and dependent work continues.
- `#require` records an issue and dependent work does not continue.

Additional verification:

```text
50 consecutive `swift test --skip-build` runs passed.
swift build -c release passed.
```

No external dependencies are used.
