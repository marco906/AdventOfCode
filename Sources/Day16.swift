import Algorithms

struct Day16: AdventDay {
  init(data: String) {
    self.map = data.split(separator: "\n").map { $0.map { String($0) } }
    numRows = map.count
    numCols = map[0].count
  }
  
  var map: [[String]] = []
  var numRows: Int
  var numCols: Int
  
  struct Position: Hashable {
    let x: Int
    let y: Int
  }
  
  func getStartPositionAndHeading() -> (Position, Position) {
    for y in 0..<map.count {
      for x in 0..<map[y].count {
        let value = map[y][x]
        switch value {
        case "S":
          return (Position(x: x, y: y), Position(x: x + 1, y: y))
        default:
          break
        }
      }
    }
    
    return (Position(x: 0, y: 0), Position(x: 0, y: 0))
  }
  
  func isObstacle(_ position: Position) -> Bool {
    guard position.x >= 0 && position.y >= 0 else { return true }
    guard position.x < numCols && position.y < numRows else { return true }
    return map[position.y][position.x] == "#"
  }
  
  func isTarget(_ position: Position) -> Bool {
    return map[position.y][position.x] == "E"
  }
  
  func move(current: Position, heading: Position, score: Int, visited: inout Set<Position>) async -> Int? {
    if isTarget(current) {
      print("found target \(current), score \(score)")
      // visited.removeAll()
      return score
    }
    
    // visited.insert(current)
    
    //print("visiting \(current), heading \(heading)")
    
    
    let dx = heading.x - current.x
    let dy = heading.y - current.y
    
    let front = Position(x: heading.x + dx, y: heading.y + dy)
    let right = Position(x: current.x - dy, y: current.y + dx)
    let left = Position(x: current.x + dy, y: current.y - dx)
    
    var scores: [Int?] = []
    
    if !isObstacle(heading) && !visited.contains(heading) {
      scores.append(await move(current: heading, heading: front, score: score + 1, visited: &visited))
    }
    
    if !isObstacle(right) && !visited.contains(right) {
      scores.append(await move(current: current, heading: right, score: score + 1000, visited: &visited))
    }
    
    if !isObstacle(left) && !visited.contains(left) {
      scores.append(await move(current: current, heading: left, score: score + 1000, visited: &visited))
    }

    //print(scores)
    return scores.compactMap { $0 }.min()
  }
  
  func part1() async -> Any {
    let start = getStartPositionAndHeading()
    let startPosition = start.0
    let startHeading = start.1
    
    var visited = Set<Position>()
    print(startPosition, startHeading)
    
    let score = await move(current: startPosition, heading: startHeading, score: 0, visited: &visited)
    
    return score ?? 0
  }
  
  func part2() async -> Any {
    var res = 0
    
    return res
  }
}
