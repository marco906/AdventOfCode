import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day16Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """

  @Test
  func testPart1() async throws {
    let challenge = Day16(data: testData)
    await #expect(String(describing: challenge.part1()) == "7036")
  }

  @Test
  func testPart2() async throws {
    let challenge = Day16(data: testData)
    await #expect(String(describing: challenge.part2()) == "0")
  }
}
