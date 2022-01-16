public protocol RegionRead where Region: Collection, Region.Element == UInt8 {
  associatedtype Region

  mutating func read(upToCount count: Int) throws -> Region
}

extension RegionRead where Self: Read, Region == [UInt8] {
  public mutating func read(upToCount count: Int) throws -> Region {
    try .init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      initializedCount = try read(into: .init(buffer))
    }
  }
}

extension RegionRead where Self: Read, Self: Seek, Region == [UInt8] {
  public mutating func read(exactly count: Int) throws -> Region {
    try .init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      try readExactlyOrSeekBack(into: .init(buffer))
      initializedCount = count
    }
  }
}
