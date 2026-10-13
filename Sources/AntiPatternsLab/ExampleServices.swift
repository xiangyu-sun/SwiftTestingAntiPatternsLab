import Foundation
import os

public final class EventSource: Sendable {
  private let continuation: AsyncStream<Int>.Continuation
  public let values: AsyncStream<Int>

  public init() {
    let pair = AsyncStream<Int>.makeStream()
    self.values = pair.stream
    self.continuation = pair.continuation
  }

  public func send(_ value: Int) {
    self.continuation.yield(value)
  }

  public func finish() {
    self.continuation.finish()
  }
}

public final class CallbackService: Sendable {
  private let callback = OSAllocatedUnfairLock<(@Sendable (Int) -> Void)?>(initialState: nil)

  public init() {}

  public var onValue: (@Sendable (Int) -> Void)? {
    get { self.callback.withLock { $0 } }
    set { self.callback.withLock { $0 = newValue } }
  }

  public func emit(_ value: Int) {
    self.callback.withLock { $0 }?(value)
  }
}

public func startEscapedWorker(
  counter: Counter,
  release: AsyncSignal,
  started: AsyncSignal,
  registry: TaskRegistry
) {
  let task = Task {
    started.signal()
    await release.wait()
    guard !Task.isCancelled else { return }
    await counter.increment()
  }
  registry.store(task)
}

public func buggyCancellation(
  counter: Counter,
  started: AsyncSignal,
  release: AsyncSignal
) async {
  started.signal()
  await release.wait()
  try? Task.checkCancellation()
  await counter.increment()
}

public func fixedCancellation(
  counter: Counter,
  started: AsyncSignal,
  release: AsyncSignal
) async {
  started.signal()
  await release.wait()
  do {
    try Task.checkCancellation()
  } catch is CancellationError {
    return
  } catch {
    return
  }

  await counter.increment()
}

public struct Profile: Equatable, Sendable {
  public let name: String

  public init(name: String) {
    self.name = name
  }
}

public enum ExtractionError: Error, Equatable {
  case missingProfile
}

public func requireProfile(_ profile: Profile?) throws -> Profile {
  guard let profile else { throw ExtractionError.missingProfile }
  return profile
}

public struct SafeAddress: Equatable, Sendable {
  public let rawValue: String

  public init?(_ rawValue: String) {
    guard rawValue.hasPrefix("https://") else { return nil }
    self.rawValue = rawValue
  }
}
