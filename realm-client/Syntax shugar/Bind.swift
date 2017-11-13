
infix operator =>> : AdditionPrecedence

public func =>> <A, B>(lhs: A?, rhs: ((A) -> B?)?) -> B? {
  return bind(argument: lhs, modifier: rhs)
}

public func bind<A, B>(argument: A?, modifier:((A) -> B?)?) -> B? {
  return argument.flatMap { modifier?($0) } ?? nil
}

extension Sequence {
  
  public func apply<T, S: Sequence>(values:S, modifier: @escaping (Element, T) -> ()?)
    where S.Element == T
  {
    _ = zip(self, values).bind(modifier: modifier)
  }
  
  public func bind<B>(modifier:((Element) -> B?)?) -> [B]? {
    return modifier.flatMap { self.flatMap($0) }
  }
}

