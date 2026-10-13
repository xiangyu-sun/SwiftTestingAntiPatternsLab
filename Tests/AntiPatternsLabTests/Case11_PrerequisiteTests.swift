import AntiPatternsLab
import Testing

@Suite("11 - Non-fatal prerequisite")
struct PrerequisiteTests {
  @Test("#expect records a known issue and continues")
  func expectContinues() async {
    let dependentWork = Counter()
    let profile: Profile? = nil
    await withKnownIssue("Intentional demonstration") {
      #expect(profile != nil)
      await dependentWork.increment()
    }
    #expect(await dependentWork.value == 1)
  }

  @Test("A failed #require stops dependent work")
  func requireStops() async {
    let dependentWork = Counter()
    let profile: Profile? = nil
    await withKnownIssue("Intentional demonstration") {
      _ = try #require(profile)
      await dependentWork.increment()
    }
    #expect(await dependentWork.value == 0)
  }
}
