public protocol Write {
  /// This method either writes the entire buffer, or throws an error if only part of the content was written.
  mutating func write(from buffer: UnsafeRawBufferPointer) throws
}
