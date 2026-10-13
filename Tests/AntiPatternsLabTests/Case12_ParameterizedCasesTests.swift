import AntiPatternsLab
import Testing

private let invalidAddresses = [
  "http://example.com",
  "javascript:alert(1)",
  "file:///tmp/private"
]

private let validAddresses = [
  "https://example.com",
  "https://example.com/path"
]

@Suite("12 - Parameterized cases")
struct ParameterizedCasesTests {
  // BAD: for address in addresses { #expect(...) } creates one aggregate result.

  @Test("Rejects selected non-HTTPS strings", arguments: invalidAddresses)
  func rejectsNonHTTPSAddress(address: String) {
    #expect(SafeAddress(address) == nil)
  }

  @Test("Accepts selected HTTPS-prefixed strings", arguments: validAddresses)
  func acceptsHTTPSPrefix(address: String) throws {
    let safeAddress = try #require(SafeAddress(address))
    #expect(safeAddress.rawValue == address)
  }
}
