public extension RegionRead where Self: Seek {
  mutating func read(exactly count: Int) throws -> Region {
    try withSeekingBackOnError { reader in
      let result = try reader.read(upToCount: count)
      let realCount = result.count
      if realCount != count {
        throw IOError.noEnoughBytes(expected: count, real: realCount)
      }
      return result
    }
  }
}
