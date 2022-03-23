import SystemPackage

public func retryOnInterrupt<R>(_ body: () throws -> R) rethrows -> R {
  repeat {
    do {
      return try body()
    } catch Errno.interrupted {

    } catch {
      throw error
    }
  } while true
}

extension Sequence where Element == UInt8 {
  func withBufferedChunk(capacity: Int, body: (UnsafeRawBufferPointer) throws -> Void) rethrows {
    let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: capacity, alignment: MemoryLayout<UInt8>.alignment)
    defer {
      buffer.deallocate()
    }

    var iterator = makeIterator()
    /*
     v1:
     var currentBufferCount = 0

     while let nextByte = iterator.next() {
     buffer[currentBufferCount] = nextByte
     currentBufferCount += 1
     if currentBufferCount == capacity {
     try body(.init(buffer))
     currentBufferCount = 0
     }
     }
     try body(UnsafeRawBufferPointer(rebasing: buffer.prefix(currentBufferCount)))
     */

    while true {
      for idx in buffer.startIndex..<buffer.endIndex {
        guard let x = iterator.next() else {
          try body(UnsafeRawBufferPointer(rebasing: buffer.prefix(idx)))
          return
        }
        buffer[idx] = x
      }
      try body(.init(buffer))
    }
  }
}
