import Foundation
import SystemPackage
import IOModule

extension RegionRead where Self: Seek, Region.Element == UInt8, Region.SubSequence: ContiguousBytes {
  public mutating func readAsMemoryStream(exactly count: Int) throws -> MemoryInputStream<Region> {
    try withOffsetUnchangedOnError { v in
      let region = try v.read(upToCount: count)
      if region.count != count {
        throw IOError.noEnoughBytes(expected: count, real: region.count)
      }
      return .init(region)
    }
  }
}

public struct MemoryInputStream<C> where C: Collection, C.Element == UInt8, C.SubSequence: ContiguousBytes {

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
    let copied = data[currentIndex..<newIndex].withUnsafeBytes { $0.copyBytes(to: buffer) }
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

    let copied = data[startIndex...].prefix(realCount).withUnsafeBytes { $0.copyBytes(to: buffer) }
    precondition(copied == realCount)
    return copied
  }
}

extension MemoryInputStream: Seek {

  public mutating func seek(offset: Int64, from whence: FileDescriptor.SeekOrigin) throws -> Int64 {
    let originIndex: C.Index
    switch whence {
    case .start: originIndex = data.startIndex
    case .end: originIndex = data.endIndex
    case .current: originIndex = currentIndex
    default:
      throw IOError.unsupportedSeekOrigin
    }
    let newIndex = data.index(originIndex, offsetBy: Int(offset))
    try check(index: newIndex)
    currentIndex = newIndex
    return numericCast(data.distance(from: data.startIndex, to: currentIndex))
  }

  private func check(index: C.Index) throws {
    if index < data.startIndex || index > data.endIndex {
      throw IOError.seekOverbound
    }
  }

}

extension MemoryInputStream: RegionRead {
  public mutating func read(upToCount count: Int) throws -> C.SubSequence {
    let realCount = min(count, data.distance(from: currentIndex, to: data.endIndex))
    let region = data[currentIndex...].prefix(realCount)
    currentIndex = data.index(currentIndex, offsetBy: realCount)
    return region
  }

  public typealias Region = C.SubSequence
}
