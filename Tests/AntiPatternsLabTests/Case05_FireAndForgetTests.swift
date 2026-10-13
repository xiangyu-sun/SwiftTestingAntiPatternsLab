import AntiPatternsLab
import Testing

@Suite("05 - Fire-and-forget task")
struct FireAndForgetTests {
  // Test instrumentation keeps a hidden handle so this package can clean up safely. A real caller
  // that discards Task {} has no such control.

  @Test("Discarded worker remains active until external cleanup")
  func escapedWorker() async {
    let counter = Counter()
    let release = AsyncSignal()
    let started = AsyncSignal()
    let registry = TaskRegistry()

    startEscapedWorker(counter: counter, release: release, started: started, registry: registry)
    await started.wait()
    #expect(await counter.value == 0)

    await registry.cancelAndWait()
    release.signal()
    #expect(await counter.value == 0)
  }

  @Test("Owned task can be cancelled and awaited")
  func ownedWorker() async {
    let release = AsyncSignal()
    let worker = Task { await release.wait() }

    worker.cancel()
    release.finish()
    await worker.value
  }
}
