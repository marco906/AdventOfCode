import Algorithms

struct Day07: AdventDay {
  init(data: String) {
    self.equations = data.split(separator: "\n").map {
      let components = $0.components(separatedBy: ": ")
      let numbers = components[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
      let result = Int(components[0]) ?? 0
      return Equation(result: result, numbers: numbers)
    }
  }
  
  struct Equation {
    let result: Int
    let numbers: [Int]
  }
  
  var equations: [Equation] = []
  
  func chooseOperator(current: Int, numbers: [Int], target: Int) -> Bool {
    if numbers.isEmpty {
      return current == target
    }
    
    var numbers = numbers
    let next = numbers.removeFirst()
    
    let addition = current + next
    if addition <= target && chooseOperator(current: addition, numbers: numbers, target: target) {
      return true
    }
    
    let multiplication = current * next
    if  multiplication <= target && chooseOperator(current: multiplication, numbers: numbers, target: target) {
      return true
    }
    
    return false
  }
  
  func part1() async -> Any {
    var res = 0
    for equation in equations {
      if chooseOperator(current: 0, numbers: equation.numbers, target: equation.result) {
        res += equation.result
      }
    }
    return res
  }
  
  func part2() async -> Any {
    return 0
  }
}
