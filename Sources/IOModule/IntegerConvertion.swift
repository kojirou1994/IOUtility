import Endianness

extension Endianness {

  @usableFromInline
  var needConvert: Bool {
    self != Self.host
  }

  @usableFromInline
  func convert<T: FixedWidthInteger>(_ value: T) -> T {
    if needConvert {
      return value.byteSwapped
    } else {
      return value
    }
  }

}
