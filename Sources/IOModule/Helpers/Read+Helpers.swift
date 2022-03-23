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
  @available(macOS 11.0, *)
  mutating func readString(byteCount: Int) throws -> String {
    try String(unsafeUninitializedCapacity: byteCount) { buffer in
      try read(exactlyInto: .init(buffer))
      return byteCount
    }
  }

  mutating func readAsBitReader<T: FixedWidthInteger>(_ type: T.Type, endian: Endianness = .big) throws -> BitReader<T> {
    try .init(readInteger(endian: endian))
  }

  mutating func readByte() throws -> UInt8 {
    try readInteger()
  }

}
