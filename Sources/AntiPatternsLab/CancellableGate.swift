import Foundation

public actor CancellableGate {
  private var isOpen = false
  private var waiters: [UUID: CheckedContinuation<Void, Error>] = [:]
  private let registrationContinuation: AsyncStream<Int>.Continuation
  public nonisolated let registrations: AsyncStream<Int>

  public init() {
    let pair = AsyncStream<Int>.makeStream(bufferingPolicy: .unbounded)
    self.registrations = pair.stream
    self.registrationContinuation = pair.continuation
  }

  public var waiterCount: Int { self.waiters.count }

  public func wait() async throws {
    if self.isOpen { return }

    let id = UUID()
    try await withTaskCancellationHandler {
      try await withCheckedThrowingContinuation { continuation in
        if self.isOpen {
          continuation.resume()
        } else if Task.isCancelled {
          continuation.resume(throwing: CancellationError())
        } else {
          self.waiters[id] = continuation
          self.registrationContinuation.yield(self.waiters.count)
        }
      }
    } onCancel: {
      Task { await self.cancel(id) }
    }
  }

  public func open() {
    self.isOpen = true
    let pending = self.waiters.values
    self.waiters.removeAll()
    pending.forEach { $0.resume() }
  }

  private func cancel(_ id: UUID) {
    if let continuation = self.waiters.removeValue(forKey: id) {
      continuation.resume(throwing: CancellationError())
    }
  }
}
