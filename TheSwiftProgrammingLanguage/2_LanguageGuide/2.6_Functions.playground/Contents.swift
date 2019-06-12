// ---- Defining and Calling Functions ---- //
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
print(greet(person: "Anna"))
print(greet(person: "Brian"))

func greetAgain(person: String) -> String {
    return "Hello again, " + person + "!"
}
greetAgain(person: "Jim")


// ---- Function Parameters and Return Values ---- //
// no input paramters
func sayHelloWorld() -> String {
    return "Hello, world"
}
sayHelloWorld()

// multiple paramters
// this is different from the greet(person:) function
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return greetAgain(person: person)
    } else {
        return greet(person: person)
    }
}
greet(person: "Tim", alreadyGreeted: true)

// no return values
func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {
    let _ = printAndCount(string: string)
}

printAndCount(string: "hello, world")
printWithoutCounting(string: "hello, world")

// multiple return values (in a tuple)
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
let bounds = minMax(array: [8, -6, 2, 109, 3, 71])

// optional tuple returns
func minMax2(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
if let bounds = minMax2(array: [8, -6, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}


// ---- Function Argumet Labels and Paramter Names ---- //
// each function paramter has an "argument label" and "parameter name"
// "argument label" is used when calling the function
// "paramter name" is used within the function
func someFunction(argumentLabel paramterName: Int) {
    print(paramterName)
}

func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))

// omit argument label with `_`
func someOtherFunction(_ firstParamterName: Int, secondParameterName: Int) {
    print(firstParamterName)
    print(secondParameterName)
}

// default paramter values
func anotherFunction(parameterWithoutDefault: Int, paramterWithDefault: Int = 12) {
    print("first parameter: \(parameterWithoutDefault), second parameter: \(paramterWithDefault)")
}
anotherFunction(parameterWithoutDefault: 3, paramterWithDefault: 6)
anotherFunction(parameterWithoutDefault: 4)

// variadic paramters can accept zero or more values of a specific type
// are available as an array of the appropriate type
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
arithmeticMean(3, 8.25, 18.75)

// in-out paramters
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let tempA = a
    a = b
    b = tempA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")


// ---- Function Types ---- //

