public extension Seek {

  mutating func rewind() throws {
    _ = try seek(offset: 0, from: .start)
  }

  /* unsafe */
  mutating func streamLength() throws -> Int64 {
    let oldPosition = try currentOffset()
    let length = try seek(offset: 0, from: .end)
    if oldPosition != length {
      _ = try seek(offset: oldPosition, from: .start)
    }
    return length
  }

  mutating func currentOffset() throws -> Int64 {
    try seek(offset: 0, from: .current)
  }

  mutating func isAtEnd() throws -> Bool {
    try currentOffset() == streamLength()
  }

  mutating func skip(_ count: Int) throws {
    _ = try seek(offset: Int64(count), from: .current)
  }

  mutating func withSeekingBackOnError<R>(_ body: (inout Self) throws -> R) throws -> R {
    let oldPosition = try currentOffset()
    do {
      return try body(&self)
    } catch {
      do {
        let fixedPosition = try seek(offset: oldPosition, from: .start)
        assert(oldPosition == fixedPosition)
      } catch {
        assertionFailure("Failed to seek back, error is ignored: \(error)")
      }
      throw error
    }
  }

}
