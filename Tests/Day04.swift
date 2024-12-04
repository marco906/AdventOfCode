import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day04Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ....XXMAS.
    .SAMXMS...
    ...S..A...
    ..A.A.MS.X
    XMASAMX.MM
    X.....XA.A
    S.S.S.S.SS
    .A.A.A.A.A
    ..M.M.M.MM
    .X.X.XMASX
    """

  @Test
  func testPart1() async throws {
    let challenge = Day04(data: testData)
    #expect(String(describing: challenge.part1()) == "18")
  }

  @Test
  func testPart2() async throws {
    let challenge = Day04(data: testData)
    #expect(String(describing: challenge.part2()) == "0")
  }
}
