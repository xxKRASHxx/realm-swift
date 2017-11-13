
public func weakify<Value: AnyObject, Arguments, Result>(
  _ function: @escaping (Value) -> (Arguments) -> Result,
  object: Value,
  default value: Result
  )
  -> (Arguments) -> Result
{
  return { [weak object] arguments in
    object.map { function($0)(arguments) } ?? value
  }
}

public func weakify<Value: AnyObject, Arguments>(
  _ function: @escaping (Value) -> (Arguments) -> (),
  object: Value
  )
  -> (Arguments) -> ()
{
  return weakify(function, object: object, default: ())
}

public func weakify<Value: AnyObject>(
  _ function: @escaping (Value) -> () -> (),
  object: Value
  )
  -> () -> ()
{
  return { [weak object] in
    object.map { function($0)() }
  }
}
