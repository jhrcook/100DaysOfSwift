// ---- Assignment Operator ---- //
let b = 10
var a = 5
a = b

let (x, y) = (1, 2)
x
y


// ---- Arithmetic ---- //
//four standard operators: +, -, *, /
// thse are protected from overflow in Swift

// string concatentation
"hello, " + "world"

// remainder operator: %
9 % 4
-9 % 4

// unary minus
let three = 3
let minusThree = -three
// there is also the unary plus operator, for completeness


// ---- Compound Assignment Operators ---- //
// combine assignment with another operation
a += 2


// ---- Comparison Operators ---- //
// main operators: ==, !=, >, <, >=, <=
// identity operators: ===, !==
1 == 1
2 != 1
2 > 1
1 < 2
1 >= 1
2 <= 1

let name = "world"
if name == "world" {
    print("Hello, world!")
}

// comparing tuples, left to right, comparing non-equivalent values, only
(1, "zebra") < (2, "apple")  // 1 < 2
(3, "apple") < (3, "bird")   // "apple" < "bird"
(4, "dog") < (4, "dog")      // all equivalent, none compared
(4, "dog") == (4, "dog")     // the tuples are equivalent

// the operator must be applicable to each value of the tuples
("blue", -1) < ("purple", 1)
//("blue", false) < ("purple", true)  // ERROR


// ---- Ternary Conditional Operator ---- //
// question ? answer1 : answer2
// shorthand for an if-else statement
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)


// ---- Nil-Coalescing Operator ---- //
// a ?? b
// unwrapsa an optional `a` if it contains a value, otherwise returns `b`
// if `a` if non-nil, `b` is not evaluated
let defaultColorName = "red"
var userDefinedColorName: String?
var colorNameToUse = userDefinedColorName ?? defaultColorName
//shorthand for
colorNameToUse = userDefinedColorName != nil ? userDefinedColorName! : defaultColorName

userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName


// ---- Range Operators ---- //
// closed range operator: a...b
//from a to b, including a and b
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

// half-open range operator: a..<b
// from a to b, not including b
let names = ["Anna", "Ales", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("Person \(i+1) is called \(names[i])")
}

// one-sided ranges
for name in names[2...] {
    print(name)
}

for name in names[...2] {
    print(name)
}

for name in names[..<2] {
    print(name)
}


// ---- Logical Operators ---- //
// modify or become boolean logic values
// standard operators: !, &&, ||

// NOT
let allowedEntry = false
if !allowedEntry {
    print("ACESS DENIED")
}

// AND
let enteredDoorCode = true
let passedRetinaScan = false
if enteredDoorCode && passedRetinaScan {
    print("Welcome.")
} else {
    print("ACCESS DEINED")
}

// OR
let hasDoorKey = false
let knowsOverridePassword = true
if hasDoorKey || knowsOverridePassword {
    print("Welcome.")
} else {
    print("ACCESS DENIED")
}

// paranthese can be used to clarify groupings of strings of logic gates
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
    print("Welcome.")
} else {
    "ACCESS DENIED"
}
