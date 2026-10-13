import AntiPatternsLab
import Testing

@Suite("06 - Cancellation-aware gate")
struct CancellableGateTests {
  @Test("Cancelling a waiter resumes it with CancellationError")
  func cancelledWaiter() async throws {
    let gate = CancellableGate()
    var registrations = gate.registrations.makeAsyncIterator()
    let waiter = Task { try await gate.wait() }

    #expect(await registrations.next() == 1)
    waiter.cancel()

    let result = await waiter.result
    guard case let .failure(error) = result else {
      Issue.record("Expected cancellation")
      return
    }
    #expect(error is CancellationError)
    #expect(await gate.waiterCount == 0)
  }

  @Test("Opening the gate releases every waiter")
  func multipleWaiters() async throws {
    let gate = CancellableGate()
    var registrations = gate.registrations.makeAsyncIterator()
    async let first: Void = gate.wait()
    async let second: Void = gate.wait()

    let firstCount = await registrations.next()
    let secondCount = await registrations.next()
    #expect(Set([firstCount, secondCount].compactMap { $0 }) == [1, 2])
    await gate.open()
    _ = try await (first, second)
  }
}
