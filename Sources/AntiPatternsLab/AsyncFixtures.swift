import Foundation
import os

public actor Counter {
  public private(set) var value = 0

  public init() {}

  public func increment() {
    self.value += 1
  }
}

public actor AsyncFlag {
  private var value = false

  public init() {}

  public func set() {
    self.value = true
  }

  public func wait() async throws {
    while !self.value {
      try Task.checkCancellation()
      await Task.yield()
    }
  }
}

public final class AsyncSignal: Sendable {
  private let continuation: AsyncStream<Void>.Continuation
  private let stream: AsyncStream<Void>

  public init() {
    let pair = AsyncStream<Void>.makeStream(bufferingPolicy: .bufferingNewest(1))
    self.stream = pair.stream
    self.continuation = pair.continuation
  }

  public func signal() {
    self.continuation.yield()
  }

  public func finish() {
    self.continuation.finish()
  }

  public func wait() async {
    var iterator = self.stream.makeAsyncIterator()
    _ = await iterator.next()
  }
}

/// Test instrumentation can retain a handle even when the simulated caller discards it.
public final class TaskRegistry: @unchecked Sendable {
  private let task = OSAllocatedUnfairLock<Task<Void, Never>?>(initialState: nil)

  public init() {}

  public func store(_ task: Task<Void, Never>) {
    self.task.withLock { $0 = task }
  }

  public func cancelAndWait() async {
    guard let task = self.task.withLock({ $0 }) else { return }
    task.cancel()
    await task.value
  }
}

public enum WaitError: Error, Equatable {
  case timedOut
}

public func boundedPoll(
  timeout: Duration = .milliseconds(20),
  condition: @escaping @Sendable () async -> Bool
) async throws {
  let clock = ContinuousClock()
  let deadline = clock.now.advanced(by: timeout)

  while !(await condition()) {
    try Task.checkCancellation()
    guard clock.now < deadline else { throw WaitError.timedOut }
    await Task.yield()
  }
}
