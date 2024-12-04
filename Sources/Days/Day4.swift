//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

// This is just a general template to use for each daiy challenge
final class Day4: Day {
  var title: String = "Ceres Search"
  var dayNum: Int = 4
  let exampleData: [Int: String] = [
    1: """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """
  ]
  
  class Node {
    let id = UUID()
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
  
  typealias WordSearchGrid = [[Character]]
  var grid = WordSearchGrid()
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = """
        Take a look at the little Elf's word search. 
        How many times does XMAS appear?            
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      grid = parseInput(input)
      let word = "XMAS"
      
      return "\(countOccurrences(of: word, in: grid))"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = true
    let question = """
        Flip the word search from the instructions back over to the word search side and try again. 
        How many times does an X-MAS appear?            
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      grid = parseInput(input)
      let word = "MAS"; let letter = Character("A")
      
      return "\(countCrossingOccurrences(of: word, at: letter, in: grid))"
    }
  }
  
  enum Directions: CaseIterable {
    case up, down, left, right, topLeft, topRight, bottomLeft, bottomRight
    
    var offset: (row: Int, col: Int) {
      switch self {
      case .up: return (-1, 0)
      case .down: return (1, 0)
      case .left: return (0, -1)
      case .right: return (0, 1)
      case .topLeft: return (-1, -1)
      case .topRight: return (-1, 1)
      case .bottomLeft: return (1, -1)
      case .bottomRight: return (1, 1)
      }
    }
  }
  
  private func countCrossingOccurrences(of word: String, at letter: Character, in grid: WordSearchGrid) -> Int {
    /// BUG:
    /// No proper solution for this part
    /// My method checks for diagonal "MAS" words then attempts to find how many
    /// time the letter "A" is found twice, indicating two crossed "MAS" words
    /// Need to understand PrefixTree better a revist this later; or look again
    /// at my logic for finding the number of "A"s in the crossed "MAS" words.
    
    let rows = grid.count
    let cols = grid[0].count
    
    let diagonalDirections: [Directions] = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    let rowBounds = 0..<rows
    let colBounds = 0..<cols
    
    struct Location: Hashable {
      let row: Int
      let col: Int
    }
    
    var crossingLetterLocationCount: [Location: Int] = [:]
    
    func search(_ row: Int, _ col: Int, _ direction: Directions, _ index: Int) -> Bool {
      guard rowBounds.contains(row), colBounds.contains(col) else { return false }
      
      guard grid[row][col] == word[word.index(word.startIndex, offsetBy: index)] else { return false }
      
      if index == word.count - 1 {
        return true
      }
      
      let offset = direction.offset
      return search(row + offset.row, col + offset.col, direction, index + 1)
    }
    
    for row in rowBounds {
      for col in colBounds {
        guard grid[row][col] == letter else { continue }
        var diagonalWordCount = 0
        
        for direction in diagonalDirections {
          if search(row, col, direction, 0) {
            diagonalWordCount += 1
          }
        }
        
        if diagonalWordCount >= 2 {
          let location = Location(row: row, col: col)
          crossingLetterLocationCount[location, default: 0] += 1
        }
      }
    }
    
    return crossingLetterLocationCount.values.filter { $0 > 1 }.count
  }
  
  private func countOccurrences(of word: String, in grid: WordSearchGrid) -> Int {
    let tree = Tree()
    tree.insert(word)
    
    let root = tree.getRoot()
    let rows = grid.count
    let cols = grid[0].count
    var wordCount = 0
    
    let rowBounds = 0..<rows
    let colBounds = 0..<cols
    
    func search(_ node: Node, _ row: Int, _ col: Int, _ direction: Directions) {
      guard rowBounds.contains(row), colBounds.contains(col) else { return }
      let char = grid[row][col]
      guard let nextNode = node.children[char] else { return }
      
      if nextNode.isWord {
        wordCount += 1
        nextNode.count += 1
      }
      
      let offset = direction.offset
      search(nextNode, row + offset.row, col + offset.col, direction)
    }
    
    for row in rowBounds {
      for col in colBounds {
        for direction in Directions.allCases {
          search(root, row, col, direction)
        }
      }
    }
    
    return wordCount
  }
  
  private func parseInput(_ input: String) -> WordSearchGrid {
    let grid: WordSearchGrid = rawDataAsArray(input, delim: .newline) { line in
      guard !line.isEmpty else { return nil }
      let row: [Character] = Array(line)
      return row.compactMap { $0 }
    }.compactMap { $0 }
    return grid
  }
}
