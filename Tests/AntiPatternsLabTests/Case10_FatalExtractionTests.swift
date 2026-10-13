import AntiPatternsLab
import Testing

@Suite("10 - Fatal extraction")
struct FatalExtractionTests {
  // BAD (commented out because it would crash the process):
  // let profile: Profile? = nil
  // _ = profile!

  @Test("Throwing extraction is recoverable instead of crashing")
  func throwingExtraction() {
    #expect(throws: ExtractionError.missingProfile) {
      _ = try requireProfile(nil)
    }
  }

  @Test("#require unwraps a valid prerequisite")
  func requiredValue() throws {
    let optionalProfile: Profile? = Profile(name: "Taylor")
    let profile = try #require(optionalProfile)

    #expect(profile.name == "Taylor")
  }
}
