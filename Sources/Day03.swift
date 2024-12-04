import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    var res = 0
    let pattern = /mul\((\d{1,3}),(\d{1,3})\)/

    for match in data.matches(of: pattern) {
      res += (Int(match.1) ?? 0) * (Int(match.2) ?? 0)
    }

    return res
  }

  func part2() -> Any {
    return 0
  }
}
