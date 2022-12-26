public protocol Write {
  /// After writing, this method increments the file’s offset by the number of bytes written.
  // can throw interrupted
  mutating func write(from buffer: UnsafeRawBufferPointer) throws -> Int
}

public protocol RandomWrite: Write {
  mutating func write(from buffer: UnsafeRawBufferPointer, atOffset offset: Int64) throws -> Int
}

extension RandomWrite where Self: Seek {
  public mutating func write(from buffer: UnsafeRawBufferPointer, atOffset offset: Int64) throws -> Int {
    try withOffsetUnchanged { write in
      try write.seek(toOffset: offset, from: .start)
      return try write.write(from: buffer)
    }
  }
}
