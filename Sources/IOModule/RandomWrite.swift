public protocol RandomWrite: Write {
  mutating func write(toAbsoluteOffset offset: Int64, _ buffer: UnsafeRawBufferPointer) throws -> Int
}

extension RandomWrite where Self: Seek {
  public mutating func write(toAbsoluteOffset offset: Int64, _ buffer: UnsafeRawBufferPointer) throws -> Int {
    try withOffsetUnchanged { write in
      try write.seek(offset: offset, from: .start)
      return try write.write(buffer)
    }
  }
}
