import Foundation

public struct Reducer<Value> {
  
  public typealias ValueType = Value
  public typealias FunctionType = (Value, Value) -> Value
  
  public var empty: ValueType
  public var function: FunctionType
  
  public init(empty: ValueType, function: @escaping FunctionType) {
    self.empty = empty
    self.function = function
  }
}

public extension Reducer where Value == Bool {
  
  public static var or: Reducer {
    return Reducer(empty: false) { $0 || $1 }
  }
  
  public static var and: Reducer {
    return Reducer(empty: true) { $0 && $1 }
  }
}

public extension Array {
  
  public func join(_ reducer: Reducer<Element>) -> Element {
    return self.reduce(reducer.empty, reducer.function)
  }
  
  public func apply<Value, Result>(_ value: Value) -> [Result]
    where Element == (Value) -> Result
  {
    return self.map { $0(value) }
  }
  
  public func apply<Value1, Value2, Result>(_ value1: Value1, _ value2: Value2) -> [Result]
    where Element == (Value1, Value2) -> Result
  {
    return self.map { $0(value1, value2) }
  }
}
