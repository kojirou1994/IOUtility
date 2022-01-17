public protocol Write {
  /// After writing, this method increments the file’s offset by the number of bytes written.
  mutating func write(_ buffer: UnsafeRawBufferPointer, retryOnInterrupt: Bool) throws -> Int
}

public extension Write {
  /// always retry on interrupt
  mutating func write(_ buffer: UnsafeRawBufferPointer) throws -> Int {
    try write(buffer, retryOnInterrupt: true)
  }
}
