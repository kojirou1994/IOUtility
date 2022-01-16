import Foundation
import SystemPackage

extension RegionRead where Self: Seek, Region: DataProtocol {
  mutating func readAsMemoryStream(exactly count: Int) throws -> MemoryInputStream<Region> {
    try seekBackOnError { v in
      let region = try v.read(upToCount: count)
      if region.count != count {
        throw IOError.noEnoughBytes
      }
      return .init(region)
    }
  }
}

public struct MemoryInputStream<C: DataProtocol> {

  public private(set) var currentIndex: C.Index

  public let data: C

  public init(_ data: C) {
    self.data = data
    currentIndex = data.startIndex
  }

}

extension MemoryInputStream: RandomRead {

  public mutating func read(into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    let realCount = min(buffer.count, data.distance(from: currentIndex, to: data.endIndex))
    if realCount == 0 {
      return 0
    }

    let newIndex = data.index(currentIndex, offsetBy: realCount)
    let copied = data[currentIndex..<newIndex].copyBytes(to: buffer)
    precondition(copied == realCount)
    currentIndex = newIndex
    return copied
  }

  public mutating func read(fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    let startIndex = data.index(data.startIndex, offsetBy: numericCast(offset))
    try check(index: startIndex)

    let realCount = min(buffer.count, data.distance(from: startIndex, to: data.endIndex))
    if realCount == 0 {
      return 0
    }

    let copied = data[startIndex...].prefix(realCount).copyBytes(to: buffer)
    precondition(copied == realCount)
    return copied
  }
}

extension MemoryInputStream: Seek {

  public mutating func seek(offset: Int64, from whence: FileDescriptor.SeekOrigin) throws -> Int64 {
    let origin: C.Index
    switch whence {
    case .start: origin = data.startIndex
    case .end: origin = data.endIndex
    case .current: origin = currentIndex
    default:
      fatalError()
    }
    let newIndex = data.index(origin, offsetBy: Int(offset))
    try check(index: newIndex)
    currentIndex = newIndex
    return numericCast(data.distance(from: data.startIndex, to: currentIndex))
  }

  private func check(index: C.Index) throws {
    if !data.indices.contains(index) {
      throw IOError.seekOverbound
    }
  }

}
