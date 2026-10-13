import AntiPatternsLab
import Testing

@Suite("02 - Unbounded callback wait")
struct UnboundedCallbackTests {
  // BAD:
  // await withCheckedContinuation { continuation in service.onValue = { continuation.resume(...) } }
  // If no value arrives, the continuation never resumes.

  @Test("Observer is installed before the producer runs")
  func observerBeforeProducer() async {
    let service = CallbackService()

    await confirmation("callback received") { callbackReceived in
      service.onValue = { value in
        #expect(value == 42)
        callbackReceived()
      }

      service.emit(42)
    }
  }
}
