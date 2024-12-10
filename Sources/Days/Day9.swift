//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

// This is just a general template to use for each daiy challenge
final class Day9: Day {
  var title: String = "Disk Fragmenter"
  var dayNum: Int = 9
  let exampleData: [Int: String] = [
    1: "12345",
    2: "2333133121414131402",
    3: "233313312141413140212333133121414131402"
  ]
  
  // 12345                -> 0..111....22222
  // 2333133121414131402  -> 00...111...2...333.44.5555.6666.777.888899
  
  struct FileData: Equatable, CustomStringConvertible {
    var id: Int?
    var size: Int
    var fixed: Bool = false // Added for pt-2, skip-over this file if it can't be moved at first attempt
    
    static func == (lhs: FileData, rhs: FileData) -> Bool {
      lhs.id == rhs.id
    }
    
    var description: String {
      guard let id else { return "." }
      return "\(id % 10)"
    }
  }
  
  enum MemoryBlock: Equatable, CustomStringConvertible {
    case freeSpace
    case file (FileData)
    
    static func == (lhs: MemoryBlock, rhs: MemoryBlock) -> Bool {
      switch (lhs, rhs) {
      case (.freeSpace, .freeSpace): return true
      case (.file(let lhs), .file(let rhs)): return lhs == rhs
      default : return false
      }
    }
    
    var description: String {
      switch self {
      case .freeSpace: return "."
      case .file(let file): return "\(file)"
      }
    }
  }
  
  struct DiskMap: CustomStringConvertible {
    var blocks: [MemoryBlock]
    var checksum: Int {
      var chksum = 0
      for (idx, block) in blocks.enumerated() {
        switch block {
        case .freeSpace: break
        case .file(let fileData) : chksum += idx * (fileData.id ?? 00)
        }
      }
      return chksum
    }
    
    mutating func compact(avoidFragmentation: Bool = false) {
        if avoidFragmentation {
              print(self)
        } else {
            // Original compact logic for Part 1
            var freeSpaceIdx = blocks.firstIndex(where: {
                if case .freeSpace = $0 { return true }
                return false
            })
            var fileIdx = blocks.lastIndex(where: {
                if case .file = $0 { return true }
                return false
            })
            
            while let freeIndex = freeSpaceIdx, let fileIndex = fileIdx, freeIndex < fileIndex {
                blocks.swapAt(freeIndex, fileIndex)
                
                freeSpaceIdx = blocks.firstIndex(where: {
                    if case .freeSpace = $0 { return true }
                    return false
                })
                fileIdx = blocks.lastIndex(where: {
                    if case .file = $0 { return true }
                    return false
                })
            }
        }
    }
    
    var description: String {
      blocks.map { "\($0)" }.joined()
    }
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = true
    let question = """
        Compact the amphipod's hard drive using the process he requested. 
        What is the resulting filesystem checksum?
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[2]! : rawInput
      var diskMap : DiskMap = parseInput(input)
      
      print(diskMap)
      diskMap.compact()
      print(diskMap)
      
      // Do something with the data
      let result: Int = diskMap.checksum
      
      
      return "\(result)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = true
    let question = """
        Start over, now compacting the amphipod's hard drive using this new method instead. 
        What is the resulting filesystem checksum?
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[2]! : rawInput
      var diskMap : DiskMap = parseInput(input)
      
      print(diskMap)
      diskMap.compact(avoidFragmentation: true)
      print(diskMap)
      
      // Do something with the data
      let result: Int = diskMap.checksum
      
      
      return "\(result)"
    }
  }
  
  private func parseInput(_ input: String) -> DiskMap {
    var diskMap: DiskMap = DiskMap(blocks: [])
    var processingFile = true
    var fileID = 0
    
    for c in input.trimmingCharacters(in: .whitespacesAndNewlines) {
      let sz: Int = Int(String(c))!
      var block: [MemoryBlock] = []
      if processingFile {
        block = Array(repeating: MemoryBlock.file(FileData(id: fileID, size: sz)), count: sz)
        fileID += 1
      } else {
        block = Array(repeating: MemoryBlock.freeSpace, count: sz)
      }
      processingFile.toggle()
      diskMap.blocks += block
    }
    
    return diskMap
  }
}
