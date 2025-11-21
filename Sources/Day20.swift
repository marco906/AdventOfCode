import Algorithms

struct Day20: AdventDay {
  init(data: String) {
    self.map = data.split(separator: "\n").map { $0.map { String($0) } }
    numRows = map.count
    numCols = map[0].count
  }
  
  var map: [[String]] = []
  var numRows: Int
  var numCols: Int
  var directions: [[Int]] = [[0,1], [0, -1], [1, 0], [-1,0]]
  
  final class Node: Hashable {
    let x: Int
    let y: Int
    var g: Int = 0
    var h: Int = 0
    var f: Int { g + h }
    
    var parents: Set<Node> = []
    var neighbors: [Node] = []
    
    static func == (lhs: Node, rhs: Node) -> Bool {
      return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(x)
      hasher.combine(y)
    }
    
    init(x: Int, y: Int, parents: Set<Node> = []) {
      self.x = x
      self.y = y
      self.parents = parents
    }
  }
  
  func getStartAndEnd() -> (Node, Node) {
    var start: Node?
    var end: Node?
    for y in 0..<numRows {
      for x in 0..<numCols {
        let value = map[y][x]
        if value == "S" {
          start = Node(x: x, y: y)
        } else if value == "E" {
          end = Node(x: x, y: y)
        }
      }
    }
    
    return (start!, end!)
  }
  
  func getNeighbors(_ node: Node) -> [Node] {
    var neighbors: [Node] = []
    for direction in directions {
      let neighbor = Node(x: node.x + direction[0], y: node.y + direction[1])
      if !isObstacle(neighbor) {
        neighbors.append(neighbor)
      }
    }
    
    return neighbors
  }
  
  func isObstacle(_ node: Node) -> Bool {
    guard node.x >= 0 && node.y >= 0 else { return true }
    guard node.x < numCols && node.y < numRows else { return true }
    return map[node.y][node.x] == "#"
  }
  
  func isTarget(_ node: Node) -> Bool {
    return map[node.y][node.x] == "E"
  }
  
  func aStar(start: Node, target: Node) -> [Node]? {
    var open = [Node]()
    var closed: Set<Node> = []
    open.append(start)
    
    while !open.isEmpty {
      open.sort { $0.f < $1.f }
      let currentNode = open.removeFirst()
      
      if currentNode == target {
        return backTrack(currentNode).first
      }
      
      closed.insert(currentNode)
      
      currentNode.neighbors = getNeighbors(currentNode)
      
      for neighbor in currentNode.neighbors {
        if closed.contains(neighbor) {
          continue
        }
        
        let newCost = currentNode.g + 1
        if !open.contains(where: { $0 == neighbor }) {
          open.append(neighbor)
        } else if newCost >= neighbor.g {
          continue
        }
        
        neighbor.g = newCost
        neighbor.h = heuristic(node: neighbor, target: target)
        neighbor.parents = [currentNode]
      }
    }
    
    return nil
  }
  
  func bestPaths(start: Node, target: Node) -> Set<[Node]>{
    var open = [Node]()
    var closed: Set<Node> = []
    open.append(start)
    var bestPaths: Set<[Node]> = []
    
    while !open.isEmpty {
      open.sort { $0.f < $1.f }
      let currentNode = open.removeFirst()
      
      if currentNode == target {
        bestPaths.formUnion(backTrack(currentNode))
        continue
      }
      
      closed.insert(currentNode)
      
      currentNode.neighbors = getNeighbors(currentNode)
      
      for neighbor in currentNode.neighbors {
        if closed.contains(neighbor) {
          continue
        }
        
        let newCost = currentNode.g + 1
        if !open.contains(where: { $0 == neighbor }) {
          open.append(neighbor)
        } else if newCost > neighbor.g {
          continue
        } else if newCost == neighbor.g {
          neighbor.parents.insert(currentNode)
          continue
        }
        
        neighbor.g = newCost
        neighbor.h = heuristic(node: neighbor, target: target)
        neighbor.parents = [currentNode]
      }
    }
    
    return bestPaths
  }
  
  func heuristic(node: Node, target: Node) -> Int {
    let dx = abs(node.x - target.x)
    let dy = abs(node.y - target.y)
    return dx + dy
  }
  
  func backTrack(_ node: Node) -> [[Node]] {
    var paths: [[Node]] = []
    var visited: Set<ObjectIdentifier> = [] // To track visited nodes and prevent cycles
    
    func traverse(_ currentNode: Node, _ currentPath: [Node]) {
      let nodeID = ObjectIdentifier(currentNode)
      
      if visited.contains(nodeID) {
        return
      }
      
      visited.insert(nodeID)
      
      var updatedPath = currentPath
      updatedPath.append(currentNode)
      
      if currentNode.parents.isEmpty {
        paths.append(updatedPath)
      } else {
        // Explore all parent nodes
        for parent in currentNode.parents {
          traverse(parent, updatedPath)
        }
      }
      
      visited.remove(nodeID)
    }
    
    traverse(node, [])
    return paths.map { $0.reversed() }
  }
  
  func part1() async -> Any {
    let (start, end) = getStartAndEnd()
    let pathNoCheat = aStar(start: start, target: end)
    let cost = pathNoCheat?.last?.g ?? 0
    print(cost)
    
    let paths = bestPaths(start: start, target: end)
    let costs: [Int] = paths.map { $0.count - 1 }
    print(costs)
    
    return cost
  }
  
  func part2() async -> Any {
    var res = 0
    
    return res
  }
}
