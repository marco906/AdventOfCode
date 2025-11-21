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
  var directions: [[Int]] = [[0,1], [0, -1], [1, 0], [-1,0]]
  
  final class Node: Hashable {
    let x: Int
    let y: Int
    var g: Int = 0
    var h: Int = 0
    var f: Int { g + h }
    
    var parent: Node?
    var parents: Set<Node> = []
    var neighbors: [Node] = []
    
    static func == (lhs: Node, rhs: Node) -> Bool {
      return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(x)
      hasher.combine(y)
    }
    
    init(x: Int, y: Int, parent: Node? = nil, parents: Set<Node> = []) {
      self.x = x
      self.y = y
      self.parent = parent
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
  
  func costToMove(from: Node, to: Node) -> Int {
    let parent = from.parent ?? Node(x: from.x - 1, y: from.y)
    let dir: [Int] = [from.x - parent.x, from.y - parent.y]
    // same dir
    if dir[0] == to.x - from.x && dir[1] == to.y - from.y {
      return 1
    }
    return 1001
  }
  
  func aStar(start: Node, target: Node) -> [Node]? {
    var open = [Node]()
    var closed: Set<Node> = []
    open.append(start)
    
    while !open.isEmpty {
      open.sort { $0.f < $1.f }
      let currentNode = open.removeFirst()
      
      if currentNode == target {
        return backTrack(currentNode)
      }
      
      closed.insert(currentNode)
      
      currentNode.neighbors = getNeighbors(currentNode)
      
      for neighbor in currentNode.neighbors {
        if closed.contains(neighbor) {
          continue
        }
        
        let newCost = currentNode.g + costToMove(from: currentNode, to: neighbor)
        if !open.contains(where: { $0 == neighbor }) {
          open.append(neighbor)
        } else if newCost >= neighbor.g {
          continue
        }
        
        neighbor.g = newCost
        neighbor.h = heuristic(node: neighbor, target: target)
        neighbor.parent = currentNode
      }
    }
    
    return nil
  }
  
  func aStarAll(start: Node, target: Node) -> [[Node]] {
      var open: [Node] = [start]
      var closed: Set<Node> = []
      
      while !open.isEmpty {
          // Sort open set based on f (priority queue would be better)
          open.sort { $0.f < $1.f }
          let currentNode = open.removeFirst()
          
          // If target is reached, continue processing to explore all paths
          if currentNode == target {
            print("Target reached")
              continue
          }
          
          closed.insert(currentNode)
          
          // Fetch neighbors
          currentNode.neighbors = getNeighbors(currentNode)
          
          for neighbor in currentNode.neighbors {
              if closed.contains(neighbor) {
                  continue
              }
              
              let newCost = currentNode.g + costToMove(from: currentNode, to: neighbor)
              
              // Add neighbor to open if it's not already there
              if !open.contains(neighbor) {
                  open.append(neighbor)
              }
              
              // If this path to the neighbor is better
              if newCost < neighbor.g {
                  neighbor.g = newCost
                  neighbor.h = heuristic(node: neighbor, target: target)
                  neighbor.parents = [currentNode] // Overwrite parents
              } else if newCost == neighbor.g {
                  // If this path to the neighbor is equally good
                  neighbor.parents.insert(currentNode) // Add an additional parent
              }
          }
      }
      
      // Return all paths by backtracking from the target
      return backTrackAll(target)
  }

  // Backtrack to find all paths
  func backTrackAll(_ node: Node) -> [[Node]] {
      var paths: [[Node]] = []
      
      func dfs(current: Node, path: [Node]) {
          if current.parents.isEmpty {
              paths.append([current] + path)
              return
          }
          
          for parent in current.parents {
              dfs(current: parent, path: [current] + path)
          }
      }
      
      dfs(current: node, path: [])
      return paths
  }
  
  func heuristic(node: Node, target: Node) -> Int {
    let dx = abs(node.x - target.x)
    let dy = abs(node.y - target.y)
    return dx + dy
  }
  
  func backTrack(_ node: Node) -> [Node] {
    var path: [Node] = []
    var currentNode: Node? = node
    while let n = currentNode {
      path.append(n)
      currentNode = n.parent
    }
    return path.reversed()
  }
  
//  func backTrackAll(_ node: Node) -> [[Node]] {
//    var paths: [[Node]] = []
//    
//    func dfs(current: Node, path: [Node]) {
//      if current.parents.isEmpty {
//        paths.append([current] + path.reversed())
//        return
//      }
//      
//      for parent in current.parents {
//        dfs(current: parent, path: path + [current])
//      }
//    }
//    
//    dfs(current: node, path: [])
//    return paths
//  }
  
  func part1() async -> Any {
    let (start, end) = getStartAndEnd()
    let path = aStar(start: start, target: end)
    let cost = path?.last?.g ?? 0
    
    return cost
  }
  
  func part2() async -> Any {
    let (start, end) = getStartAndEnd()
    let paths = aStarAll(start: start, target: end)
    
    print(paths)
    
    print(paths.flatMap { $0 }.count)
    
    return Set(paths.flatMap { $0 }).count
  }
}
