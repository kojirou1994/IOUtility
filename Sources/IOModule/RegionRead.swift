public protocol RegionRead where Region: Collection, Region.Element == UInt8 {
  associatedtype Region

  mutating func read(upToCount count: Int) throws -> Region
}

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
}
