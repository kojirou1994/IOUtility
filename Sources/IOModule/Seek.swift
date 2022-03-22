import SystemPackage

public protocol Seek {
  @discardableResult
  mutating func seek(toOffset offset: Int64, from origin: FileDescriptor.SeekOrigin) throws -> Int64
}
