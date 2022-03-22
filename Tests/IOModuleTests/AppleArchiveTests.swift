#if canImport(AppleArchive)
import XCTest
import IOModule
import IOStreams
import AppleArchive
import SystemPackage
import System

extension ArchiveByteStream: Seek, RandomRead, RandomWrite {
  public func seek(toOffset offset: Int64, from origin: SystemPackage.FileDescriptor.SeekOrigin) throws -> Int64 {
    try seek(toOffset: offset, relativeTo: System.FileDescriptor.SeekOrigin(rawValue: origin.rawValue))
  }

}

class AppleArchiveTests: XCTestCase {
}
#endif
