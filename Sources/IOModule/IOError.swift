public enum IOError: Error {
  case noEnoughBytes(expected: Int, real: Int)
  case seekOverbound
  case unsupportedSeekOrigin
}

extension IOError: Sendable {}
