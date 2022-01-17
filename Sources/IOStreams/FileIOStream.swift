import Endianness
import SystemPackage
import IOModule

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

  public func write(_ buffer: UnsafeRawBufferPointer, retryOnInterrupt: Bool) throws -> Int {
    try fd.write(buffer, retryOnInterrupt: retryOnInterrupt)
  }

  public func seek(offset: Int64, from whence: FileDescriptor.SeekOrigin) throws -> Int64 {
    try fd.seek(offset: offset, from: whence)
  }

}
