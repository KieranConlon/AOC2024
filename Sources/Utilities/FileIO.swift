//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

func readDataFromFile(inputFolder: String, day: Int) -> String {
  let fileName = "inputD\(day).txt"
  let filePath = inputFolder + fileName
  
  return (try? String(contentsOf: URL(fileURLWithPath: filePath), encoding: .utf8)) ?? ""
}

enum SeparatorToken: String {
  case dblNewline = "\n\n"
  case newline = "\n"
  case space = " "
  case comma = ","
  case tab = "\t"
  case pipe = "|"
  case colon = ":"
  case commaSpace = ", "
  case semicolonSpace = "; "
}

func rawDataAsArray<T>(_ raw: String, delim: SeparatorToken, convert: (String) -> T?) -> [T] {
  let components = raw.components(separatedBy: delim.rawValue)
  return components.compactMap(convert)
}
