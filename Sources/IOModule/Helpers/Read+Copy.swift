private let DEFAULT_BUF_SIZE = 8 * 1024

extension Read where Self: ~Copyable {
  public mutating func copy<W: Write>(to writer: inout W) throws -> Int {
    var length = 0
    try withUnsafeTemporaryAllocation(byteCount: DEFAULT_BUF_SIZE, alignment: MemoryLayout<UInt8>.alignment) { buffer in
      while true {
        let readSize = try read(into: buffer)
        guard readSize > 0 else {
          return
        }
        length += readSize
        try writer.writeAll(UnsafeRawBufferPointer(rebasing: buffer.prefix(readSize)))
      }
    }
    return length
  }
}

/*
 ref:
 https://doc.rust-lang.org/src/std/io/copy.rs.html#53-65
 */
