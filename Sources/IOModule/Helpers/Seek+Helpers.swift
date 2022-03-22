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

  mutating func withOffsetUnchangedOnError<R>(_ body: (inout Self) throws -> R) throws -> R {
    try _withOffsetUnchanged(onErrorOnly: true, body)
  }

  mutating func withOffsetUnchanged<R>(_ body: (inout Self) throws -> R) throws -> R {
    try _withOffsetUnchanged(onErrorOnly: false, body)
  }

  private mutating func _withOffsetUnchanged<R>(onErrorOnly: Bool, _ body: (inout Self) throws -> R) throws -> R {
    let oldPosition = try currentOffset()
    func seekBack() throws {
      let fixedPosition = try seek(offset: oldPosition, from: .start)
      assert(oldPosition == fixedPosition)
    }
    let result: R
    do {
      result = try body(&self)
    } catch {
      do {
        try seekBack()
      } catch {
        // Failed to seek back, error is ignored
      }
      throw error
    }
    if !onErrorOnly {
      try seekBack()
    }
    return result
  }

}
