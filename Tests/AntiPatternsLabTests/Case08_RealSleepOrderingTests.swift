import AntiPatternsLab
import Testing

@Suite("08 - Explicit synchronization")
struct ExplicitSynchronizationTests {
  // BAD:
  // let worker = Task { await work() }
  // try? await Task.sleep(for: .milliseconds(200))
  // #expect(await workerReachedExpectedState())
  // Elapsed time does not establish that the worker reached any particular state.

  @Test("Explicit signal establishes ordering")
  func signalEstablishesOrdering() async {
    let signal = AsyncSignal()
    let worker = Task {
      signal.signal()
    }

    await signal.wait()
    await worker.value
  }
}
