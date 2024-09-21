public extension RegionRead where Self: ~Copyable {
  mutating func read(exactCount count: Int) throws -> Region {
    let result = try read(upToCount: count)
    let realCount = result.count
    if realCount != count {
      throw IOError.noEnoughBytes(expected: count, real: realCount)
    }
    return result
  }

}

public extension RegionRead where Self: ~Copyable & Seek {

  mutating func readToEnd() throws -> Region {
    let count = try streamLength() - currentOffset()
    return try read(exactCount: Int(count))
  }

}
