public protocol RandomRead: Read {
  /// this method leaves the stream's existing offset unchanged.
  mutating func read(into buffer: UnsafeMutableRawBufferPointer, atOffset offset: Int64) throws -> Int
}

extension RandomRead where Self: Seek {
  public mutating func read(into buffer: UnsafeMutableRawBufferPointer, atOffset offset: Int64) throws -> Int {
    try withOffsetUnchanged { read in
      try read.seek(toOffset: offset, from: .start)
      return try read.read(into: buffer)
    }
  }
}
