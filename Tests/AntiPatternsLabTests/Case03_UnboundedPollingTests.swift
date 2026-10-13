import AntiPatternsLab
import Testing

@Suite("03 - Unbounded polling")
struct UnboundedPollingTests {
  // BAD:
  // while await counter.value == 0 { await Task.yield() }

  @Test("Bounded poll fails instead of hanging")
  func boundedPolling() async {
    let counter = Counter()

    await #expect(throws: WaitError.timedOut) {
      try await boundedPoll(timeout: .milliseconds(5)) {
        await counter.value > 0
      }
    }
  }

  @Test("Explicit signal avoids polling")
  func explicitSignal() async {
    let signal = AsyncSignal()
    let worker = Task { await signal.wait() }

    signal.signal()
    await worker.value
  }
}
