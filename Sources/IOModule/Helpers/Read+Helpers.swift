import Endianness
import SystemPackage
import BitReader

extension Read {
  mutating func readExactly(into buffer: UnsafeMutableRawBufferPointer) throws {
    let length = try read(into: .init(buffer))
    if length != buffer.count {
      throw IOError.noEnoughBytes(expected: buffer.count, real: length)
    }
  }
}

extension Read where Self: Seek {
  mutating func readExactlyOrSeekBack(into buffer: UnsafeMutableRawBufferPointer) throws {
    try withSeekingBackOnError { read in
      try read.readExactly(into: buffer)
    }
  }
}

public extension Read where Self: Seek {

  mutating func readInteger<T: FixedWidthInteger>(size: Int = MemoryLayout<T>.size, endian: Endianness = .big, as: T.Type = T.self) throws -> T {
    precondition(1...MemoryLayout<T>.size ~= size)
    var value: T = 0
    try withUnsafeMutableBytes(of: &value) { buffer in
      try readExactlyOrSeekBack(into: .init(start: buffer.baseAddress, count: size))
    }
    return endian.convert(value)
  }

  /// Read UTF-8 String
  /// - Parameter count: utf8 unit count
  /// - Throws: read error
  /// - Returns: String
  @available(macOS 11.0, *)
  mutating func readString(exactly count: Int) throws -> String {
    try String(unsafeUninitializedCapacity: count) { buffer in
      try readExactlyOrSeekBack(into: .init(buffer))
      return count
    }
  }

  mutating func readAsBitReader<T: FixedWidthInteger>(_ type: T.Type, endian: Endianness = .big) throws -> BitReader<T> {
    try .init(readInteger(endian: endian))
  }

  mutating func readByte() throws -> UInt8 {
    try readInteger()
  }

}
