public protocol RandomRead: Read {
  /// this method leaves the stream's existing offset unchanged.
  mutating func read(fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer) throws -> Int
}

extension RandomRead where Self: Seek {
  public mutating func read(fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    try withOffsetUnchanged { read in
      try read.seek(offset: offset, from: .start)
      return try read.read(into: buffer)
    }
  }
}
