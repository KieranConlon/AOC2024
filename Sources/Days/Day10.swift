//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

// This is just a general template to use for each daiy challenge
final class Day10: Day {
  var title: String = "Hoof It"
  var dayNum: Int = 10
  let exampleData: [Int: String] = [
    1: """
    ...0...
    ...1...
    ...2...
    6543456
    7.....7
    8.....8
    9.....9
    """,
    2: """
    ..90..9
    ...1.98
    ...2..7
    6543456
    765.987
    876....
    987....
    """,
    3: """
    10..9..
    2...8..
    3...7..
    4567654
    ...8..3
    ...9..2
    .....01
    """,
    4: """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """
  ]
  
  enum MapCell: Character, CustomStringConvertible {
    case impassable = "."
    case trailhead = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    
    var description: String {
      String(self.rawValue)
    }
  }
  
  enum Directions: CaseIterable {
    case north, south, east, west
    
    var offset: (row: Int, col: Int) {
      switch self {
      case .north: return (-1, 0)
      case .south: return (1, 0)
      case .east: return (0, 1)
      case .west: return (0, -1)
      }
    }
  }
  
  class Node {
    var children: [Character: Node] = [:]
    var isWord: Bool = false
    var count: Int = 0
  }
  
  class Tree {
    private let root = Node()
    func insert(_ word: String) {
      var current = root
      for char in word {
        if current.children[char] == nil {
          current.children[char] = Node()
        }
        current = current.children[char]!
      }
      current.isWord = true
    }
    
    func getRoot() -> Node {
      return root
    }
  }
  
  struct Position: Hashable {
    let row: Int
    let col: Int
  }
  
  struct TopographicMap: CustomStringConvertible {
    var rowBounds: Range<Int> { 0..<grid.count }
    var colBounds: Range<Int> { 0..<(grid.first?.count ?? 0) }
    
    var grid: [[MapCell]]
    
    func findTrailheads() -> Int {
      let tree = Tree()
      tree.insert("0123456789")
      
      let root = tree.getRoot()
      var endTrail: Set<Position> = []
      var totalScore = 0
      
      func search(_ node: Node, _ row: Int, _ col: Int) -> Bool {
        guard rowBounds.contains(row), colBounds.contains(col) else { return false }
        
        let cell = grid[row][col]
        guard let nextNode = node.children[cell.rawValue] else { return false }
        
        if nextNode.isWord {
          endTrail.insert(Position(row: row, col: col))
          
        }
        
        for direction in Directions.allCases {
          let offset = direction.offset
          _ = search(nextNode, row + offset.row, col + offset.col)
        }
        
        return false
      }
      
      for row in rowBounds {
        for col in colBounds {
          // Only start the search from a trailhead start position
          if grid[row][col] == .trailhead {
            endTrail.removeAll()
            _ = search(root, row, col)
            totalScore += endTrail.count
          }
        }
      }
      
      return totalScore
    }
    
    func findTrailheadRatings() -> Int {
      let tree = Tree()
      tree.insert("0123456789")
      
      let root = tree.getRoot()
      var visited: Set<Position> = []
      var totalRating = 0
      
      func search(_ node: Node, _ row: Int, _ col: Int) -> Int {
        guard rowBounds.contains(row), colBounds.contains(col) else { return 0 }
        guard !visited.contains(Position(row: row, col: col)) else { return 0 }
        
        let cell = grid[row][col]
        guard let nextNode = node.children[cell.rawValue] else { return 0 }
        
        visited.insert(Position(row: row, col: col))
        var distinctTrails = 0
        
        if nextNode.isWord {
          distinctTrails += 1
        }
        
        for direction in Directions.allCases {
          let offset = direction.offset
          distinctTrails += search(nextNode, row + offset.row, col + offset.col)
        }
        
        visited.remove(Position(row: row, col: col))
        return distinctTrails
      }
      
      for row in rowBounds {
        for col in colBounds {
          if grid[row][col] == .trailhead {
            visited.removeAll()
            totalRating += search(root, row, col)
          }
        }
      }
      
      return totalRating
    }
    
    var description: String {
      grid.map { row in
        row.map { "\($0.rawValue)" }.joined()
      }.joined(separator: "\n")
    }
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "What is the sum of the scores of all trailheads on your topographic map?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[4]! : rawInput
      
      var topoMap: TopographicMap = TopographicMap(grid: [])
      topoMap.grid = parseInput(input)
      
      return "\(topoMap.findTrailheads())"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "What is the sum of the ratings of all trailheads?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[4]! : rawInput
      
      var topoMap: TopographicMap = TopographicMap(grid: [])
      topoMap.grid = parseInput(input)
      
      return "\(topoMap.findTrailheadRatings())"
    }
  }
  
  private func parseInput(_ input: String) -> [[MapCell]] {
    
    let grid: [[MapCell]] = rawDataAsArray(input, delim: .newline) { line in
      guard !line.isEmpty else { return nil }
      let cells: [MapCell] = line.map { char in
        return MapCell(rawValue: char)!
      }
      return cells
    }.compactMap { $0 }
    
    return grid
  }
}
