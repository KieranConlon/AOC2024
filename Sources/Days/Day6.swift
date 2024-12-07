//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

final class Day6: Day {
  var title: String = "Guard Gallivant"
  var dayNum: Int = 6
  let exampleData: [Int: String] = [
    1: """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """,
    2: ""
  ]
  
  struct Location: Hashable, CustomStringConvertible {
    let row: Int
    let col: Int
    
    static func + (lhs: Location, rhs: Location) -> Location {
      Location(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
    }
    
    var description: String {
      "\(row),\(col)"
    }
  }
  
  enum GuardLookingDirection: Character, CaseIterable {
    case north = "^"
    case south = "v"
    case east = ">"
    case west = "<"

    var offset: Location {
      switch self {
      case .north: return Location(row: -1, col: 0)
      case .south: return Location(row: 1, col: 0)
      case .east: return Location(row: 0, col: 1)
      case .west: return Location(row: 0 , col: -1)
      }
    }
    
    var turn: GuardLookingDirection {
      switch self {
      case .north: return .east
      case .east: return .south
      case .south: return .west
      case .west: return .north
      }
    }
  }
  
  enum MapPosition: Equatable {
    case empty
    case patrolGuard(GuardLookingDirection)
    case obstruction
    case visited
    
    var mapIcon: Character {
      switch self {
      case .empty: return "."
      case .patrolGuard(let direction): return direction.rawValue
      case .obstruction: return "#"
      case .visited: return "X"
      }
    }
  }
  
  struct LabMap: CustomStringConvertible {
    var map: [[MapPosition]]
    
    mutating func doPatrol() -> Int {
      
      let rowBounds = 0..<map.count
      let colBounds = 0..<map[0].count
      
      guard let initialPosition = guardLocation else { fatalError("Guard not found on map!") }
      
      var currentPosition = initialPosition
      var visitedPositions: Set<Location> = []
      
      while rowBounds.contains(currentPosition.row) && colBounds.contains(currentPosition.col) {
        guard case let .patrolGuard(currentDirection) = map[currentPosition.row][currentPosition.col] else { fatalError("Guard not found on map!") }

        visitedPositions.insert(currentPosition)
        let offset = currentDirection.offset
        let nextPosition = currentPosition + offset

        if rowBounds.contains(nextPosition.row) && colBounds.contains(nextPosition.col) {
          let nextCell = map[nextPosition.row][nextPosition.col]
          
          switch nextCell {
          case .empty, .visited:
            map[currentPosition.row][currentPosition.col] = .visited
            map[nextPosition.row][nextPosition.col] = .patrolGuard(currentDirection)
            currentPosition = nextPosition
          case .obstruction:
            map[currentPosition.row][currentPosition.col] = .patrolGuard(currentDirection.turn)
          default :
            print("Found unknown position!")
            
          }
        } else {
          map[currentPosition.row][currentPosition.col] = .visited
          break
        }
      }
      
      return visitedPositions.count
    }
    
    var guardLocation: Location? {
      for (rowIndex, row) in map.enumerated() {
        if let colIndex = row.firstIndex(where: { position in
          if case .patrolGuard(_) = position { return true }
          return false
        }) {
          return Location(row: rowIndex, col: colIndex)
        }
      }
      return nil
    }
    
    init(mapData: [String]) {
      self.map = mapData.map { row in
        row.map { char in
          switch char {
          case ".": return .empty
            case "#": return .obstruction
          case "^": return .patrolGuard(.north)
          case "v": return .patrolGuard(.south)
          case">": return .patrolGuard(.east)
          case "<": return .patrolGuard(.west)
          default:
            fatalError("Unknown character \(char) in map data.")
          }
        }
      }
    }
    
    var description: String {
      map.map { row in
        row.map { String($0.mapIcon) }.joined()
      }.joined(separator: "\n")
    }
    
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = """
        Predict the path of the guard. 
        How many distinct positions will the guard visit before leaving the mapped area?
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput

      var map: LabMap = parseInput(input)
      print(map)
      let guardLocation = map.guardLocation
      print("Guard location: \(guardLocation?.description ?? "Unknown")")
      print("Starting patrol...")
      let numVisitedPositions = map.doPatrol()
      print("Patrol complete.")
      print(map)

      return "\(numVisitedPositions)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    //let useExampleData: Bool = false
    let question = "Question for part 2."
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      //let input = useExampleData ? exampleData[1]! : rawInput
      //      let _: ModelForChallenge = parseInput(input)
      
      // Do something with the data
      let result: Int = 999
      
      
      return "\(result)"
    }
  }
  
  private func parseInput(_ input: String) -> LabMap {
    let lines: [String] = rawDataAsArray(input, delim: .newline) { $0 }.compactMap { $0 }
    
    return LabMap(mapData: lines)
  }
  
}
