//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

final class Day1: Day {
  var title: String = "Historian Hysteria"
  var dayNum: Int = 1
  let exampleData: [Int: String] = [
    1: """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """
  ]
  
  struct LocationList {
    var list1: [Int] = []
    var list2: [Int] = []
    
    mutating func addPair(_ first: Int, _ second: Int) {
      list1.append(first)
      list2.append(second)
    }
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "Find the total distance between the left list and the right list, add up the distances between all of the pairs you found."
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      let locationList: LocationList = parseInput(input)
      
      let totalDistance = zip(locationList.list1.sorted(), locationList.list2.sorted()).reduce(0) { partialResult, values in
        partialResult + abs(values.0 - values.1)
      }
      
      return "\(totalDistance)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "Once again consider your left and right lists. What is their similarity score?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      let locationList: LocationList = parseInput(input)
      
      let list2Counts = locationList.list2.reduce(into: [:]) { value, count in
        value[count, default: 0] += 1
      }
      
      let similarityScore = locationList.list1.map { value in
        value * (list2Counts[value] ?? 0)
      }.reduce(0, +)
      
      return "\(similarityScore)"
    }
  }
  
  private func parseInput(_ input: String) -> LocationList {
      let pairs: [(Int, Int)] = rawDataAsArray(input, delim: .newline) { line in
          guard !line.isEmpty else { return nil }
          let pair = line.components(separatedBy: "   ")
          guard pair.count == 2,
                  let first = Int(pair[0]), let second = Int(pair[1]) else { return nil }
          return (first, second)
      }
      .compactMap { $0 } // Remove nil entries
      
      // Use the pairs to create the LocationList
      return pairs.reduce(into: LocationList()) { locationList, pair in
          locationList.addPair(pair.0, pair.1)
      }
  }
}
