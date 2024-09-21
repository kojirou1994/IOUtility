import SystemPackage

public protocol Seek: ~Copyable {
  @discardableResult
  mutating func seek(toOffset offset: Int64, from origin: FileDescriptor.SeekOrigin) throws -> Int64
}
