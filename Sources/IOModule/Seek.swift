import SystemPackage

public protocol Seek {
  @discardableResult
  mutating func seek(offset: Int64, from whence: FileDescriptor.SeekOrigin) throws -> Int64
}
