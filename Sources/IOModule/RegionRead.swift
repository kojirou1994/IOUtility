public protocol RegionRead where Region: Collection, Region.Element == UInt8 {
  associatedtype Region

  mutating func read(upToCount count: Int) throws -> Region
}

import struct Foundation.Data

extension RegionRead where Self: Read {
  public mutating func read(upToCount count: Int) throws -> Region where Region == [UInt8] {
    try .init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      initializedCount = try read(into: .init(buffer))
    }
  }

  public mutating func read(upToCount count: Int) throws -> Region where Region == ContiguousArray<UInt8> {
    try .init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      initializedCount = try read(into: .init(buffer))
    }
  }

  public mutating func read(upToCount count: Int) throws -> Region where Region == Data {
    guard count > 0 else {
      return .init()
    }
    let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: count, alignment: MemoryLayout<UInt8>.alignment)
    do {
      let count = try read(into: buffer)
      return .init(bytesNoCopy: buffer.baseAddress!, count: count, deallocator: .free)
    } catch {
      buffer.deallocate()
      throw error
    }
  }
}
