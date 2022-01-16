public struct BitReader<T: FixedWidthInteger> {

  public let value: T

  public var offset: UInt8 = 0 {
    willSet {
      precondition(newValue <= T.bitWidth, "offset must be less than \(T.bitWidth)")
    }
  }

  @inlinable
  public init(_ value: T) {
    self.value = value
  }

  @inlinable
  public var availableBitCount: UInt8 {
    UInt8(T.bitWidth) - offset
  }

  @inlinable
  public var isAtEnd: Bool {
    offset == T.bitWidth
  }

  @inlinable
  public mutating func readBit() -> T? {
    read(1)
  }

  @inlinable
  public mutating func readByte() -> UInt8? {
    read(8).map { UInt8(truncatingIfNeeded: $0) }
  }

  @inlinable
  public mutating func readBool(zeroValue: Bool = false) -> Bool? {
    read(1).map {$0 == 0 ? zeroValue : !zeroValue}
  }

  @inlinable
  public mutating func readAll() -> T? {
    read(availableBitCount)
  }

  @inlinable
  public mutating func read(_ count: UInt8) -> T? {
    guard availableBitCount >= count, count > 0 else {
      return nil
    }
    defer {
      offset += count
    }

    return (value << offset) >> (UInt8(T.bitWidth)-count)
  }
}
