import Endianness
import SystemPackage

public struct FileIOStream: RandomRead, Seek, Write {

  public let fd: FileDescriptor

  public init(fd: FileDescriptor) {
    self.fd = fd
  }

  public func read(into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    try fd.read(into: buffer)
  }

  public func read(fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    try fd.read(fromAbsoluteOffset: offset, into: buffer)
  }

  public func write(from buffer: UnsafeRawBufferPointer) throws -> Int {
    try fd.writeAll(buffer)
  }

  public func seek(offset: Int64, from whence: FileDescriptor.SeekOrigin) throws -> Int64 {
    try fd.seek(offset: offset, from: whence)
  }

}
