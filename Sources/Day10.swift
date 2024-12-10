import Algorithms

struct Day10: AdventDay {
  init(data: String) {
    self.map = data.split(separator: "\n").map { $0.map { Int(String($0)) ?? 0 } }
    numRows = map.count
    numCols = map[0].count
  }
  
  var map: [[Int]] = []
  var numRows: Int
  var numCols: Int

  var directions: [[Int]] = [[0,1], [0, -1], [1, 0], [-1,0]]

  struct Position: Hashable {
    var x: Int
    var y: Int
  }

  func isInBounds(_ position: Position) -> Bool {
    guard position.x >= 0 && position.y >= 0 else { return false }
    guard position.x < numCols && position.y < numRows else { return false }
    return true
  }

  func hike(pos: Position, score: inout Int, vistited: inout [Position:Int]) {
    let scoreBefore = score
//    if let visitedScore = vistited[pos] {
//      score += visitedScore
//      return
//    }

    let height = map[pos.y][pos.x]
    if height == 9 {
      vistited[pos] = 1
      score += 1
      return
    }

    for dir in directions {
      let newPos = Position(x: pos.x + dir[0], y: pos.y + dir[1])
      guard isInBounds(newPos), map[newPos.y][newPos.x] == height + 1 else {
        continue
      }
      print(newPos)
      hike(pos: newPos, score: &score, vistited: &vistited)
    }

    vistited[pos] = score - scoreBefore
  }

  func part1() async -> Any {
    var res = 0
    var visited = [Position:Int]()

    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let value = map[y][x]
        if value == 0 {
          var score = 0
          hike(pos: Position(x: x, y: y), score: &score, vistited: &visited)
          res += score
          print(score)
        }
      }
    }

    return res
  }
  
  func part2() async -> Any {
   return 0
  }
}
