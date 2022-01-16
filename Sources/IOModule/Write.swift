public protocol Write {
  mutating func write(from buffer: UnsafeRawBufferPointer) throws -> Int
}
