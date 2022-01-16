public protocol RandomRead: Read {
  /// this method leaves the stream's existing offset unchanged.
  mutating func read(fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer/*, retryOnInterrupt: Bool*/) throws -> Int
}

extension RandomRead where Self: Seek {
  public mutating func read(fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    let oldOffset = try currentOffset()
    try seek(offset: offset, from: .start)
    let size = try read(into: buffer)
    try seek(offset: oldOffset, from: .start)
    return size
  }
}
