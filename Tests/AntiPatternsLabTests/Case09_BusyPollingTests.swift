import AntiPatternsLab
import Testing

@Suite("09 - Busy polling")
struct BusyPollingTests {
  @Test("Monotonic bounded polling terminates locally")
  func boundedFailure() async {
    await #expect(throws: WaitError.timedOut) {
      try await boundedPoll(timeout: .milliseconds(5)) { false }
    }
  }

  @Test("Event-driven waiting avoids polling")
  func eventDriven() async {
    let stateChanged = AsyncSignal()
    let transition = Task {
      stateChanged.signal()
    }

    await stateChanged.wait()
    await transition.value
  }
}
