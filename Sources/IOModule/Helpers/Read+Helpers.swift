import Endianness
import SystemPackage
import BitReader

extension Read {
  mutating func read(exactlyInto buffer: UnsafeMutableRawBufferPointer) throws {
    let length = try read(into: .init(buffer))
    if length != buffer.count {
      throw IOError.noEnoughBytes(expected: buffer.count, real: length)
    }
  }
}

public extension Read {

  mutating func readInteger<T: FixedWidthInteger>(byteCount: Int = MemoryLayout<T>.size, endian: Endianness = .big, as: T.Type = T.self) throws -> T {
    precondition(1...MemoryLayout<T>.size ~= byteCount)
    var value: T = 0
    try withUnsafeMutableBytes(of: &value) { buffer in
      try read(exactlyInto: .init(start: buffer.baseAddress, count: byteCount))
    }
    return endian.convert(value)
  }

  /// Read UTF-8 String
  /// - Parameter count: utf8 unit count
  /// - Throws: read error
  /// - Returns: String
  mutating func readString(byteCount: Int) throws -> String {
    if #available(macOS 11.0, *) {
      return try String(unsafeUninitializedCapacity: byteCount) { buffer in
        try read(exactlyInto: .init(buffer))
        return byteCount
      }
    } else {
      let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: byteCount, alignment: MemoryLayout<UInt8>.alignment)
      defer {
        buffer.initializeMemory(as: UInt8.self, repeating: 0)
        buffer.deallocate()
      }
      try read(exactlyInto: buffer)
      return String(decoding: buffer, as: UTF8.self)
    }
  }

  mutating func readAsBitReader<T: FixedWidthInteger>(_ type: T.Type, endian: Endianness = .big) throws -> BitReader<T> {
    try .init(readInteger(endian: endian))
  }

  mutating func readByte() throws -> UInt8 {
    try readInteger()
  }

}
