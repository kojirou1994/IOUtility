import Foundation
import IOModule

extension Stream {
  fileprivate func checkResult(_ number: Int) throws -> Int {
    if _slowPath(number < 0) {
      assert(number == -1)
      if let error = streamError {
        throw error
      } else {
        assertionFailure("-1 but no error!")
        return 0
      }
    }
    return number
  }
}

extension InputStream: Read {
  public func read(into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    guard let baseAddress = buffer.baseAddress else {
      return 0
    }
    return try checkResult(read(baseAddress.assumingMemoryBound(to: UInt8.self), maxLength: buffer.count))
  }
}

//extension InputStream: RegionRead {
//
//  public typealias Region = Data
//
//}

extension OutputStream: Write {
  public func write(_ buffer: UnsafeRawBufferPointer, retryOnInterrupt: Bool) throws -> Int {
    guard let baseAddress = buffer.baseAddress else {
      return 0
    }
    return try checkResult(write(baseAddress.assumingMemoryBound(to: UInt8.self), maxLength: buffer.count))
  }
}


