import AntiPatternsLab
import Testing

@Suite("01 - Escaped stream task")
struct EscapedStreamTaskTests {
  // BAD:
  // Task { for await value in source.values { ... } }
  // The discarded task can outlive its test.

  @Test("Owned stream consumer is finished and awaited", .timeLimit(.minutes(1)))
  func ownedConsumer() async throws {
    let source = EventSource()
    let received = Counter()
    let consumed = AsyncSignal()

    let consumer = Task {
      for await _ in source.values {
        await received.increment()
        consumed.signal()
      }
    }

    source.send(1)
    await consumed.wait()
    source.finish()
    await consumer.value

    #expect(await received.value == 1)
  }
}
