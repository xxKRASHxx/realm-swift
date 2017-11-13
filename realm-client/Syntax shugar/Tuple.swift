import Foundation

public func +<A, B, C>(lhs: (A, B), rhs: (C)) -> (A, B, C) {
  return (lhs.0, lhs.1, rhs)
}

public func +<A, B, C>(lhs: (A), rhs: (B, C)) -> (A, B, C) {
  return (lhs, rhs.0, rhs.1)
}

