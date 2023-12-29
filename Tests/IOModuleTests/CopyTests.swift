import XCTest
import IOModule
import IOStreams

class CopyTests: XCTestCase {

  func testCopyStream() throws {
    var src = [UInt8](repeating: 0, count: 1_000_000)
    var dst = OutputStream.toMemory()
    dst.open()

    for i in src.indices {
      src[i] = .random(in: 0...UInt8.max)
    }

    var srcStream = MemoryInputStream(src)
    let written = try srcStream.copy(to: &dst)
    XCTAssertEqual(written, src.count)

    let dstBytes = dst.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
    XCTAssertTrue(src.elementsEqual(dstBytes))
  }

}
