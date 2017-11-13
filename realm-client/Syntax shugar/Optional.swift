import Foundation

public extension Optional {
  public func flatten<Result>() -> Result? where Wrapped == Result? {
    return self.flatMap { $0.flatMap { $0 } }
  }
}

public extension Optional {
  typealias Action = (Wrapped) -> ()
  public func `do`(_ action: Action?) {
    try? action.map(self.map)
  }
}

public extension Optional {
  
  public func apply<Result>(_ function: ((Wrapped) -> Result?)?) -> Result? {
    return function.flatMap { function in
      self.flatMap(function)
    }
  }
  
  public func apply<Value, Result>(_ value: Value?) -> Result?
    where Wrapped == (Value) -> Result?
  {
    return self.flatMap { value.apply($0) } ?? nil
  }
}
