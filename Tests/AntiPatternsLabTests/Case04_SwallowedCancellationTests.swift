import AntiPatternsLab
import Testing

@Suite("04 - Swallowed cancellation")
struct SwallowedCancellationTests {
  @Test("try? allows stale work after cancellation")
  func buggyVersion() async {
    let counter = Counter()
    let started = AsyncSignal()
    let release = AsyncSignal()
    let task = Task {
      await buggyCancellation(counter: counter, started: started, release: release)
    }

    await started.wait()
    task.cancel()
    release.signal()
    await task.value

    #expect(await counter.value == 1)
  }

  @Test("CancellationError prevents the stale side effect")
  func fixedVersion() async {
    let counter = Counter()
    let started = AsyncSignal()
    let release = AsyncSignal()
    let task = Task {
      await fixedCancellation(counter: counter, started: started, release: release)
    }

    await started.wait()
    task.cancel()
    release.signal()
    await task.value

    #expect(await counter.value == 0)
  }
}
