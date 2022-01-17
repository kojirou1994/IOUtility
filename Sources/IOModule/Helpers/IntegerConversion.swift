import Endianness

extension Endianness {

  @usableFromInline
  func convert<T: FixedWidthInteger>(_ value: T) -> T {
    if self != Self.host {
      return value.byteSwapped
    } else {
      return value
    }
  }

}
