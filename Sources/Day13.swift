import Algorithms

struct Day13: AdventDay {
  init(data: String) {
    let machineData = data.split(separator: "\n\n").map { String($0) }
    for entry in machineData {
      let a = /Button A: X\+(\d+), Y\+(\d+)/
      let b = /Button B: X\+(\d+), Y\+(\d+)/
      let price = /Prize: X=(\d+), Y=(\d+)/
      
      let aMatch = entry.firstMatch(of: a)!
      let bMatch = entry.firstMatch(of: b)!
      let priceMatch = entry.firstMatch(of: price)!
      
      let aPos = Position(x: Int64(aMatch.1)!, y: Int64(aMatch.2)!)
      let bPos = Position(x: Int64(bMatch.1)!, y: Int64(bMatch.2)!)
      let pricePos = Position(x: Int64(priceMatch.1)!, y: Int64(priceMatch.2)!)
      
      machines.append(Machine(a: aPos, b: bPos, price: pricePos))
    }
  }
  
  struct Machine {
    var a: Position
    var b: Position
    let costA = 3
    let costB = 1
    var price: Position
  }
  
  struct Position: Hashable {
    var x: Int64
    var y: Int64
  }
  
  var machines = [Machine]()
  
  func move(from: Position, direction: Position, cost: Int, m: Machine, costs: Int, visited: inout Set<Position>) -> Int? {
    let costs = costs + cost
    let prize = m.price
    let newPos = Position(x: from.x + direction.x, y: from.y + direction.y)
    if visited.contains(newPos) {
      return nil
    } else if newPos == prize {
      return costs
    } else if newPos.x > prize.x || newPos.y > prize.y {
      visited.insert(newPos)
      return nil
    }
    
    visited.insert(newPos)
    
    if let btnA = move(from: newPos, direction: m.a, cost: m.costA, m: m, costs: costs, visited: &visited) {
      return btnA
    }
    if let btnB = move(from: newPos, direction: m.b, cost: m.costB, m: m, costs: costs, visited: &visited) {
      return btnB
    }
    return nil
  }

  func part1() async -> Any {
    var costs = 0
    
    for m in machines {
      guard m.price.x < 100 * (m.a.x + m.b.x) && m.price.y < 100 * (m.a.y + m.b.y) else {
        continue
      }
      
      var visted = Set<Position>()
      let start = Position(x: 0, y: 0)
      costs += move(from: start, direction: start, cost: 0, m: m, costs: 0, visited: &visted) ?? 0
    }
    
    return costs
  }
  
  func part2() async -> Any {
    var costs: Int64 = 0
    
    for m in machines {
      
      // mathematical solution
      let offset: Int64 = 10000000000000
      let py = m.price.y + offset
      let px = m.price.x + offset
      
      let a = (py * m.b.x - px * m.b.y) / (m.a.y * m.b.x - m.a.x * m.b.y)
      let b = (px - m.a.x * a) / m.b.x
      let dx = a * m.a.x + b * m.b.x
      let dy = a * m.a.y + b * m.b.y
      
      if dx == px && dy == py {
        costs += a * Int64(m.costA) + b * Int64(m.costB)
      }
    }
    
    return costs
  }
}
