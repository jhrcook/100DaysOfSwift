// ---- Closure Expressions ---- //
// way to write inline closured in a brief, focused syntax
// (use the `sorted(by:)` method as an example)

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

// the sorted method accepts a closure that takes two values and returns
// a Bool for whether the first value should appear first (i.e. they are
// already sorted)

// we are using an array of `String`, so we need a `(String, String) -> Bool`
// typed closure
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)

// this is a long way to effectively write `a > b`
// can shorten using closure expression syntax:

// verbose closure syntax looks identical to function
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// can be written on a single line
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 })

// type inference from context
// Swift can infer the types from those demanded by the `sorted` method
// `sorted(by:)` called on an array of String must be `(String, String) -> Bool`
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2})

// implicit returns for single expression closures
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })

// shorthand argument names automatically supplied by Swift
// $0, $1, $2, ...
reversedNames = names.sorted(by: { $0 > $1 })


// ---- Trailing Closures` ---- //
// if the final argument of a function can be a closure
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // do a thing
}

// without a trailing closure
someFunctionThatTakesAClosure(closure: {
    // some closure code
})

// with a trailing closure
someFunctionThatTakesAClosure() {
    // some closure code
}

// trailing closure with the `sort(by:)` method
reversedNames = names.sorted() { $0 > $1 }

// if a closure is the ONLY argument for a function,
// can omit the () in `fxnName()`
reversedNames = names.sorted { $0 > $1 }

// using the `map(_:)` method of arrays
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
print(strings)


// ---- Capturing Values ---- //
// capture constants and variables from the surrounding context
// can refer and modify within the closure
// example: nested function
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
// the `incrementer()` nested function retains `runningTotal` and `amount`
// from the surrounding function
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen()
incrementByTen()
incrementByTen()

let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
incrementBySeven()

incrementByTen()


// ---- Closures Are Reference Types ---- //
// Assigning a function or closure to a constant or variable sets that
// constant or variable to be a REFERENCE to the function or closure.
// Therefore, assigning a closure to two different constants or variables,
// both the thos constants or variables refer to the same closure
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
incrementByTen()
// both `alsoIncrementByTen` and `incrementByTen` refer to the same closure


// ---- Escaping Closures ---- //
// a closure escapes a function when it is passed as an argument to the
// function, but is CALLED after the function returns

// escape by defining a closure in a variable outside of the function
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)

// the first closure in `completionHandlers` is `{ self.x = 100 }`
completionHandlers.first?()
print(instance.x)


// ---- Autoclosures ---- //

