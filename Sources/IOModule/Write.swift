public protocol Write {
  /// After writing, this method increments the file’s offset by the number of bytes written.
  mutating func write(_ buffer: UnsafeRawBufferPointer) throws -> Int
}
