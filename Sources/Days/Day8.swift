//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

// This is just a general template to use for each daiy challenge
final class Day8: Day {
  var title: String = "Resonant Collinearity"
  var dayNum: Int = 8
  let exampleData: [Int: String] = [
    1: """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    
    """,
    2: """
    ..........
    ..........
    ..........
    ....a.....
    ........a.
    .....a....
    ..........
    ..........
    ..........
    ..........
    """
  ]
  
  typealias Frequency = Character
  
  // Make this Hashable so we can use it in a Set
  // Make it Equatable, just in case we need it
  // Add operators for subtract, add and multiply
  struct Position: Hashable, Equatable {
    let row: Int
    let col: Int
    
    static func == (lhs: Position, rhs: Position) -> Bool {
      lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    static func - (lhs: Position, rhs: Position) -> Position {
      Position(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
    }
    
    static func + (lhs: Position, rhs: Position) -> Position {
      Position(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
    }
    
    static func * (pos: Position, scalar: Int) -> Position {
      Position(row: pos.row * scalar, col: pos.col * scalar)
    }
    static func * (scalar: Int, pos: Position) -> Position {
      pos * scalar
    }
  }
  
  enum CellType: CustomStringConvertible {
    case empty
    case antinode
    case node(Frequency)
    case nodeWithAntiNode(Frequency)
    
    var mapIcon: Frequency {
      switch self {
      case .empty: return "."
      case .node(let name): return name
      case .antinode: return "#"
      case .nodeWithAntiNode(let name): return name
      }
    }
    
    static func from(_ frequnecy: Frequency) -> CellType {
      if frequnecy == "#" { return .antinode }
      if frequnecy.isLetter || frequnecy.isNumber { return .node(frequnecy) }
      return .empty
    }

    var description: String { String(mapIcon) }
  }
  
  struct MapCell: CustomStringConvertible {
    var type: CellType
    
    var description: String {
      String(type.mapIcon)
    }
  }
  
  struct Map: CustomStringConvertible {
    var cells: [[MapCell]]
    let rowBounds: Range<Int>
    let colBounds: Range<Int>
    
    init(cells: [[MapCell]]) {
      self.cells = cells
      self.rowBounds = 0..<cells.count
      self.colBounds = 0..<(cells.first?.count ?? 0)
    }
    
    var description: String {
      cells.map { row in
        row.map { "\($0)" }.joined()
      }.joined(separator: "\n")
    }
    
    private func getNodes() -> [(position: Position, frequency: Frequency)] {
      var nodes: [(position: Position, frequency: Frequency)] = []
      for (rowIdx, row) in cells.enumerated() {
        for (colIdx, cell) in row.enumerated() {
          if case let .node(frequency) = cell.type {
            nodes.append((position: Position(row: rowIdx, col: colIdx), frequency: frequency))
          }
        }
      }
      return nodes
    }
    
    private func calculateAntinodes(includeHarmonics: Bool) -> [Position] {
      let nodes = getNodes()
      // Use a Set as we only need to know unique antinode locations
      var antinodePositions: Set<Position> = []
      
      for (idx, node) in nodes.enumerated() {
        for jdx in idx+1..<nodes.count {
          let otherNode = nodes[jdx]
          
          // exit early if the frequency of the nodes is different
          guard node.frequency == otherNode.frequency else { continue }
          
          let diff = otherNode.position - node.position
          
          var antinodePosition1 = otherNode.position + diff
          var antinodePosition2 = node.position - diff
          
          if inBounds(antinodePosition1) {
            antinodePositions.insert(antinodePosition1)
          }
          if inBounds(antinodePosition2) {
            antinodePositions.insert(antinodePosition2)
          }
          
          if includeHarmonics {
            // Harmonics assessment requires that we start with the zeroth harmonic
            // i.e. every antenna pair are also antinodes
            var harmonicCount = 0
            
            while true {
              antinodePosition1 = otherNode.position + (harmonicCount * diff)
              antinodePosition2 = node.position - (harmonicCount * diff)
              
              if !inBounds(antinodePosition1) && !inBounds(antinodePosition2) { break }
              
              if inBounds(antinodePosition1) {
                antinodePositions.insert(antinodePosition1)
              }
              if inBounds(antinodePosition2) {
                antinodePositions.insert(antinodePosition2)
              }
              harmonicCount += 1
            }
          }
        }
      }
      
      return Array(antinodePositions)
    }
    
    private func inBounds(_ position: Position) -> Bool {
      rowBounds.contains(position.row) && colBounds.contains(position.col)
    }
    
    mutating func addAntinodes(includeHarmonics: Bool = false) -> Int {
      let antinodePositions = calculateAntinodes(includeHarmonics: includeHarmonics)
      var antinodeCount: Int = 0
      
      for position in antinodePositions {
        guard inBounds(position) else { continue }
        
        switch cells[position.row][position.col].type {
        case .empty:
          // Add a new antinode
          cells[position.row][position.col].type = .antinode
          antinodeCount += 1
        case .node(let frequency):
          // Convert to a nodeWithAntiNode if it becomes an antinode
          cells[position.row][position.col].type = .nodeWithAntiNode(frequency)
          antinodeCount += 1
        case .nodeWithAntiNode, .antinode:
          // Already counted; no additional count
          continue
        }
      }
      
      return antinodeCount
    }
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = """
      Calculate the impact of the signal. 
      How many unique locations within the bounds of the map contain an antinode?
      """
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      var map = parseInput(input)
      
      return "\(map.addAntinodes())"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = """
        Calculate the impact of the signal using this updated model. 
        How many unique locations within the bounds of the map contain an antinode?        
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      var map = parseInput(input)
      
      let startmap = map
      let harmonicCount = map.addAntinodes(includeHarmonics: true)
      let endmap = map
      
      let count = startmap.cells.count
      for i in 0..<count {
        print("\(startmap.cells[i].map { "\($0)" }.joined())  |  \(endmap.cells[i].map { "\($0)" }.joined())")
      }
      
      
      return "\(harmonicCount)"
    }
  }
  
  private func parseInput(_ input: String) -> Map {
    let rows: [[MapCell]] = rawDataAsArray(input, delim: .newline) { line in
      guard !line.isEmpty else { return nil }
      
      let cell: [MapCell] = line.map { char in
        let cellType = CellType.from(char)
        return MapCell(type: cellType)
      }
      return cell
    }.compactMap { $0 }
    
    return Map(cells: rows)
  }
}
