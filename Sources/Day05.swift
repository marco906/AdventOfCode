import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var dataComponents: [String] {
    data.split(separator: "\n\n").map { String($0) }
  }
  
  var rules: [[Int]] {
    dataComponents[0].split(separator: "\n").map { $0.components(separatedBy: "|").compactMap { Int($0) } }
  }
  
  var updates: [[Int]] {
    dataComponents[1].split(separator: "\n").map { $0.components(separatedBy: ",").compactMap { Int($0) } }
  }
  
  func part1() -> Any {
    var res = 0
    let rulesDict = rules.reduce(into: [Int : Set<Int>]()) { $0[$1[1], default: []].insert($1[0]) }
    
    updateLoop: for pages in updates {
      var pagesAfter = Set(pages)

      for page in pages {
        pagesAfter.remove(page)
        let pagesRequiredBefore = rulesDict[page] ?? []

        if pagesRequiredBefore.isEmpty || pagesAfter.isDisjoint(with: pagesRequiredBefore) {
          // page is valid
        } else {
          continue updateLoop
        }
      }
      
      let middleIndex = pages.count / 2
      res += pages[middleIndex]
    }
    
    return res
  }
  
  func part2() -> Any {
    return 0
  }
}
