import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var matrix: [[String]] {
    data.split(separator: "\n").map { $0.map { String($0) } }
  }
  
  var rows: [String] {
    matrix.map { $0.joined() }
  }
  
  var columns: [String] {
    guard let first = matrix.first else { return [] }
    let indices = first.indices
    
    return indices.map { index in
      matrix.map { $0[index] }.joined()
    }
  }
  
  var diagonals: [String] {
    guard !matrix.isEmpty && matrix.count == matrix[0].count else {
        return [] // Ensure the matrix is non-empty and symmetric
    }
    
    let size = matrix.count
    var diagonals = [String]()
    
    // Downward diagonals
    for d in -(size - 1)..<size {
        var diagonal = [String]()
        for i in 0..<size {
            let j = i + d
            if j >= 0 && j < size {
                diagonal.append(matrix[i][j])
            }
        }
      diagonals.append(diagonal.joined())
    }
    
    // Upward diagonals
    for d in 0..<(2 * size - 1) {
        var diagonal = [String]()
        for i in 0..<size {
            let j = d - i
            if j >= 0 && j < size {
                diagonal.append(matrix[i][j])
            }
        }
      diagonals.append(diagonal.joined())
    }
    
    return diagonals
  }
  
  func part1() -> Any {
    let pattern = /XMAS/
    let patternReverse = /SAMX/
    
    var count = 0
    
    for vector in rows + columns + diagonals {
      count += vector.matches(of: pattern).count
      count += vector.matches(of: patternReverse).count
    }
    
    return count
  }
  
  func part2() -> Any {
    return 0
  }
}
