import Algorithms

struct Day09: AdventDay {
  var data: String

  func getBlocks() -> [Int?] {
    var res = [Int?]()
    var id = 0
    var isSpace = false
    for c in data {
      let num = Int(String(c)) ?? 0
      res += Array(repeating: isSpace ? nil : id, count: num)
      if !isSpace {
        id += 1
      }
      isSpace.toggle()

    }
    return res
  }

  func part1() async -> Any {
    var blocks = getBlocks()
    var i = 0
    var j = blocks.count - 1

    while i < j {
      if blocks[j] == nil {
        j -= 1
        continue
      } else if blocks[i] != nil {
        i += 1
        continue
      } else {
        blocks.swapAt(i, j)
        i += 1
        j -= 1
      }
    }

    return blocks.indices.reduce(0) { $0 + $1 * (blocks[$1] ?? 0) }
  }
  
  func part2() async -> Any {
    return 0
  }
}
