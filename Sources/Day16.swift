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
  
  func move(current: Position, heading: Position, score: Int, visited: inout [Position:Int], optimium: inout Int) async -> Int? {
    visited[current] = -1
    
    if isObstacle(current) {
      return nil
    }
    
    if isTarget(current) {
      //print("found target \(current), score \(score)")
      optimium = min(optimium, score)
      return score
    }

    let dx = heading.x - current.x
    let dy = heading.y - current.y
    
    let front = Position(x: heading.x + dx, y: heading.y + dy)
    let right = Position(x: current.x - dy, y: current.y + dx)
    let left = Position(x: current.x + dy, y: current.y - dx)
    
    var scores: [Int?] = []
    // var visited = visited
    
    func moveFront() async {
      if let frontScore = await move(current: heading, heading: front, score: score + 1, visited: &visited, optimium: &optimium) {
        scores.append(frontScore)
        visited[heading] = frontScore - score
      }
    }
    
    func moveRight() async {
      if let rightScore = await move(current: current, heading: right, score: score + 1000, visited: &visited, optimium: &optimium) {
        scores.append(rightScore)
        visited[right] = rightScore - score
      }
    }
    
    func moveLeft() async {
      if let leftScore = await move(current: current, heading: left, score: score + 1000, visited: &visited, optimium: &optimium) {
        scores.append(leftScore)
        visited[left] = leftScore - score
      }
    }
    

    if let visitedFront = visited[heading] {
      if visitedFront >= 0 {
        if visitedFront + score >= optimium {
          print("ignoring \(visitedFront), score \(score), optimium \(optimium)")
          scores.append(score + visitedFront)
        } else {
          await moveFront()
        }
      }
    } else {
      await moveFront()
    }
    
    if let visitedRight = visited[right] {
      if visitedRight >= 0 {
        if visitedRight + score >= optimium {
          scores.append(score + visitedRight)
        } else {
          await moveRight()
        }
      }
    } else {
      await moveRight()
    }
    
    if let visitedLeft = visited[left] {
      if visitedLeft >= 0 {
        if visitedLeft + score >= optimium {
          scores.append(score + visitedLeft)
        } else {
          await moveLeft()
        }
      }
    } else {
      await moveLeft()
    }

    return scores.compactMap { $0 }.min()
  }
  
  func part1() async -> Any {
    let start = getStartPositionAndHeading()
    let startPosition = start.0
    let startHeading = start.1
    
    var visited = [Position:Int]()
    print(startPosition, startHeading)
    var optimum = Int.max
    
    let score = await move(current: startPosition, heading: startHeading, score: 0, visited: &visited, optimium: &optimum)
    
    return score ?? 0
  }
  
  func part2() async -> Any {
    var res = 0
    
    return res
  }
}
