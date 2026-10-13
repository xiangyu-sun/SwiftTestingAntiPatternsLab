import AntiPatternsLab
import Testing

@Suite("07 - Async iterator lifetime")
struct AsyncIteratorTests {
  // BAD: let value = await iterator.next() with no owner, producer completion, or test deadline.

  @Test("A cancelled consumer returns nil", .timeLimit(.minutes(1)))
  func cancellationReleasesNext() async {
    let source = EventSource()
    let subscribed = AsyncSignal()

    let consumer = Task { () -> Int? in
      var iterator = source.values.makeAsyncIterator()
      subscribed.signal()
      return await iterator.next()
    }

    await subscribed.wait()
    consumer.cancel()

    let value = await consumer.value

    #expect(value == nil)
  }

  @Test("A finished producer returns nil")
  func producerCompletionReleasesNext() async {
    let source = EventSource()
    let consumer = Task {
      var iterator = source.values.makeAsyncIterator()
      return await iterator.next()
    }

    source.finish()
    #expect(await consumer.value == nil)
  }
}
