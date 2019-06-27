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
// can subclass any class that can be accessed in the current context
// subclass cannot have a higher access level that it's superclass
// subclass can override any class member
// an override can make an inherited class member more accessible
// example: `A` is publicwith file-private method `someMethod()`
//   class `B` is sub of `A` with reduced access
//   class `B` overrides `someMEthod()` and makes it internal (higher than original)
public class A {
    fileprivate func someMethod() { }
}

internal class B: A {
    override internal func someMethod() {
        // call to restricted super method within allowed context
        super.someMethod()
    }
}


// ---- Constants, Variables, Properties, and Subscripts ---- //
// cannot be more public than its type
// if use a private type, must mark the var as private, too
private var privateInstance = SomePrivateClass()

// getters and setters automatically recieve the same access level as the
// constant, var, property, or  subscript they belong to
// can make setter lower access than getter to control read-write access
struct TrackedString {
    // numberOfEdits can only be set within the structure
    private(set) var  numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}

var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits).")
// stringToEdit.numberOfEdits = 1  // error: inaccessible

// different access levels for getter and setter
public struct TrackedString2 {
    public private(set) var numberOfEdits = 0
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() { }
}


// ---- Initializers ---- //
// can have custom initializers that are lower or equal access level than type
// exception: required init must have same access level as class

// default init has same access level as the type it initializes
//   (except for public types)


// ---- Protocols ---- //
// define access at definition
// all properties of the protocol automatically have same access level


// ---- Extensions ---- //
// can extend in any access context where the type is available
// new members have same defualt access level as original type
// can mark an extension with a specific access level
// can define specific levels for new members

// extensions in the same file as the type they extend behave as if the code
// in the extension had been written as part of the original type declation
protocol SomeProtocol {
    func doSomething()
}

struct SomeStruct {
    private var privateVariable = 12
}

extension SomeStruct: SomeProtocol {
    func doSomething() {
        // access to a private var in original declaration
        print(privateVariable)
    }
}

