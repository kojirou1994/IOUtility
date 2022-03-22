public protocol RandomWrite: Write {
  mutating func write(from buffer: UnsafeRawBufferPointer, atOffset offset: Int64) throws -> Int
}

extension RandomWrite where Self: Seek {
  public mutating func write(from buffer: UnsafeRawBufferPointer, atOffset offset: Int64) throws -> Int {
    try withOffsetUnchanged { write in
      try write.seek(toOffset: offset, from: .start)
      return try write.write(buffer)
    }
  }
}
