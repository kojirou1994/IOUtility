public protocol Read {
  mutating func read(into buffer: UnsafeMutableRawBufferPointer) throws -> Int

}

extension Read {
  mutating func readExactly(into buffer: UnsafeMutableRawBufferPointer) throws {
    let length = try read(into: .init(buffer))
    if length != buffer.count {
      throw IOError.noEnoughBytes
    }
  }
}
