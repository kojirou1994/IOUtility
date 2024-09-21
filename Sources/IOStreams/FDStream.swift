import Endianness
import SystemPackage
import IOModule

public struct FDStream: RandomRead, Seek, RandomWrite, ~Copyable, Sendable {

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
    try fd.write(buffer, retryOnInterrupt: false)
  }

  public func write(toAbsoluteOffset offset: Int64, _ buffer: UnsafeRawBufferPointer) throws -> Int {
    try fd.write(toAbsoluteOffset: offset, buffer, retryOnInterrupt: false)
  }

  public func seek(toOffset offset: Int64, from origin: FileDescriptor.SeekOrigin) throws -> Int64 {
    try fd.seek(offset: offset, from: origin)
  }

}

extension FDStream: RegionRead {
  public typealias Region = [UInt8]
}
