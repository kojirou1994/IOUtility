public extension Write {

  @discardableResult
  mutating func writeAll(_ buffer: UnsafeRawBufferPointer) throws -> Int {
    var idx = 0
    while idx < buffer.count {
      idx += try retryOnInterrupt {
        try write(from: UnsafeRawBufferPointer(rebasing: buffer[idx...]))
      }
    }
    assert(idx == buffer.count)
    return buffer.count
  }

  @discardableResult
  mutating func writeAll<S: Sequence>(_ sequence: S, bufferCapacity: Int = 1024) throws -> Int where S.Element == UInt8 {
    if let fastResult = try sequence.withContiguousStorageIfAvailable({ try writeAll(UnsafeRawBufferPointer($0)) }) {
      return fastResult
    }

    precondition(bufferCapacity > 0)

    var count = 0
    try sequence.withBufferedChunk(capacity: bufferCapacity) {
      count += try writeAll($0)
    }

    return count
  }

}

public extension RandomWrite {

  @discardableResult
  mutating func writeAll(_ buffer: UnsafeRawBufferPointer, atOffset offset: Int64) throws -> Int {
    var idx = 0
    while idx < buffer.count {
      idx += try retryOnInterrupt {
        try write(from: UnsafeRawBufferPointer(rebasing: buffer[idx...]), atOffset: offset + Int64(idx))
      }
    }
    assert(idx == buffer.count)
    return buffer.count
  }

  @discardableResult
  mutating func writeAll<S: Sequence>(_ sequence: S, atOffset offset: Int64, bufferCapacity: Int = 1024) throws -> Int where S.Element == UInt8 {
    if let fastResult = try sequence.withContiguousStorageIfAvailable({ try writeAll(UnsafeRawBufferPointer($0), atOffset: offset) }) {
      return fastResult
    }

    precondition(bufferCapacity > 0)

    var count = 0
    try sequence.withBufferedChunk(capacity: bufferCapacity) {
      count += try writeAll($0, atOffset: offset + Int64(count))
    }

    return count
  }

}
