// ---- The Problem That Generics Solve ---- //
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now\(someInt), anotherInt is now \(anotherInt)")
// but `swapInt()` can only be used with Int values
// would need to copy the function to work for Doubles, Strings, etc.

// ---- Generic Functions ---- //
// use placeholder type `T`
// the `<T>` tells Swift the `T` is a placeholder type
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// swap Int
someInt = 3
anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
print("someInt is now\(someInt), anotherInt is now \(anotherInt)")

// swap String
var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
print("someString is now \(someString), anotherString is now \(anotherString)")


// ---- Type Paramters ---- //
// the placeholder type `T` in the previous example is replaced with the actual
// type the values of type `T` have when the function is called


// ---- Naming Type Paramters ---- //
// traditional to use "T", "U", and "V", when a more relevant name is not
// obvious (like with `Dictionary<Key, Value>`)

// ---- Generic Types ---- //
// custom classes, structs, enums that work with any type
// examples: `Array` and `Dictionary`

// example: create `Stack`: ordered array that can only be added to ("pushed")
// or removed from ("popped") at the end

// non-generic version
struct IntStack {
    var items = [Int]()
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// generic version
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}


var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
let fromTheTop = stackOfStrings.pop()
print(fromTheTop)

// ---- Extending a Generic Type ---- //
// do not provide a type paramter list in the extension's definition
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \"\(topItem)\".")
}


// ---- Type Constrains ---- //
// only let some types use the generic

// non-generic function
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}


// generic function with restrictions on the type
// the type must be equatable
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14, 0.1, 0.25])
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcom", "Andrea"])


// ---- Associated Types ---- //
// gives a placeholder name to a type that is used as part of the protocol
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// form of `IntStack` that conforms to generic `Container` protocol
struct IntStack2: Container {
    
    // original `IntStack` struct
    var items = [Int]()
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    
    // conformance to protocol `Container`
    typealias Item = Int
    
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// form of `Stack` that conforms to generic `Container` protocol
struct Stack2<Element>: Container {
    // original `Stack<Element>` struct
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    
    // conformance to protocol `Container`
    // typealias Item = Element  // unnecessary: type inferred by Swift
    
    mutating func append(_ item: Element) {
        self.push(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Element {
        return items[i]
    }
}

 // extend an existing type with a protocol
 extension Array: Container {}
 
 // add constains to an associated type
 // example: another version of `Container` with resircitions on `Item`
 protocol Container2 {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
 }

 // a protocol can appear as part of its own requirements
 protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
 }

 extension Stack2: SuffixableContainer {
    func suffix(_ size: Int) -> Stack2 {
        var result = Stack2()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
 }
var stackOfInts = Stack2<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
let suffix = stackOfInts.suffix(2)


// ---- Generic Where Clauses ---- //
// constrain the type paramters for associated types
func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    if someContainer.count != anotherContainer.count { return false }
    
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] { return false}
    }
    
    return true
}

var stackOfStrings2 = Stack2<String>()
stackOfStrings2.push("uno")
stackOfStrings2.push("dos")
stackOfStrings2.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings2, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}


// ---- Extensions with a Generic Where Clause ---- //
// use a generic where clause as part of an extension
extension Stack2 where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        // guard against the stack is empty
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
// not all Stack2 instances that have elements that are equaltable, now has
// the `.isTop()` method
if stackOfStrings2.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element is something else.")
}

// error on run-time with Stack2 with non-equatable items
struct NotEquatable { }
var notEquatableStack = Stack<NotEquatable>()
let notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)
notEquatableStack.push(notEquatableValue)
//notEquatableStack.isTop(notEquatableValue) // Error

// use a generic where clause with extensiosn to a protocol
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}

// a generic where clause that requires Item to be a specific type
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
[1260.0, 1200.0, 98.6, 37.0].average()


// ---- Associated Types with a Generic Where Clause ---- //
// include a generic where clause on an associated type
protocol Container3 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

protocol ComparableContainer: Container where Item: Comparable { }


// ---- Generic Subscripts ---- //
// subscripts can be generics and can include a where caluse
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
