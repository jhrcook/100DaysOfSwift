// ---- Access Control Syntax ---- //
public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}


// ---- Custom Types ---- //
// specify the access level for a custom type with definition

// explicitly public class
public class SomePublicClass2 {
    public var somePublicProperty = 0  // explicitly public class member
    var someInternalProperty = 0  // implicitly internal class member
    
    fileprivate func someFilePrivateMethod() {}
    private func somePrivateMethod() {}
}

// tuples are of access level of the most restrictive of their values

// functions are of access level of the most restrictive of their
//   paramters or return values; the func must be prefaced with the access
//   level identifier, too

// cases of an enum have the same access level as the enum
// any raw values/associated types in an enum must have access level at least
//   as high as the enum
public enum CompassPoint {
    case north, south, east, west
}


// ---- Subclassing ---- //
// <#Text#>
