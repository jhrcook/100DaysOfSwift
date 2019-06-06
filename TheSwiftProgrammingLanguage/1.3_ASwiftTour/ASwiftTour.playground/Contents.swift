print("Hello, world!")

// ---- Simple Values ---- //

// variables and constants
var myVariable = 42
myVariable = 50
let myConstant = 42


// specifying type
let implicitInt = 70
let implicitDbl = 70.0
let explicitDbl: Double = 70

// converting types
let label = "The width is "
let width = 94
let widthLabel = label + String(width)
// without the `String` conversion:
// ERROR: Binary operator '+' cannot be applied to operands of type 'String' and 'Int'

// another method for including values in strings
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let orangeSummary = "I have \(oranges) oranges."

// can use the \() for arithmetic -- careful with floats
let orangesToApples = "I have \(apples/oranges) apples to oranges."
let preciseOrangesToApples = "I have \(Double(apples)/Double(oranges)) apples to oranges."

// can use \() to insert other strings
let randomPhrase = "Here is a phrase I used earlier: '\(appleSummary)'"

// multi-line strings
let quotation = """
I said "I have \(apples) apples."
And then I said, "I have \(apples + oranges) pieces of fruit."
"""

// arrays
var shoppingList = ["catfish", "water", "tulips"]
shoppingList[1] = "bottle of water"
shoppingList.append("blue paint")

// dictionaries
var occupations = [
    "Malcolm": "Captian",
    "Kaylee": "Mechanic",
]
occupations["Malcolm"]
occupations["Jayne"] = "PR"

// empty arrays and dicts
//explicitly typed
let emptyArray = [String]()
let emptyDict = [String: Float]()
// if type can be inferred later
shoppingList = []
occupations = [:]


// ---- Control Flow ---- //
// parantheses around condition or loop variable are optional
// braces around body are required
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}
print(teamScore)

// optionals
var optionalString: String? = "Hello"
var optionalStringEmpty: String?
print(optionalString == nil)
print(optionalStringEmpty == nil)

// without without assignment
var optionalName: String? = nil
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
}
print(greeting)

// optional with assignment
optionalName = "Johnny Appleseed"
if let name = optionalName {
    greeting = "Hello, \(name)"
}
print(greeting)

// default value for optional
let nickName: String? = nil
let fullName: String = "Johnny Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

// switch-case
let vegtable = "red pepper"
switch vegtable {
case "celery":
    print("Add some raisins and makes ants on a log")
case "cucumber", "watercress":
    print("That would make some good tea sandwiches")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}


// for loops
let interestingNumbers = [
    "Prime": [2,3,5,7,11,13],
    "Fibonacci": [1,1,2,3,5,8],
    "Square": [4,9,16,25],
]
var largest = 0
var largestKind: String?
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largestKind = kind
            largest = number
        }
    }
}
print(largest)
print(largestKind ?? "No largest kind")

// while loops
// the condition can be at the end of the loop to
//   ensure the loop is run at least once
var n = 2
while n < 100 {
    n *= 2
}
print(n)

var m = 2
repeat {
    m *= 2
} while  m < 100
print(m)

// indexing in a loop
// exclude the upper bound with ..<
var total = 0
for i in 0..<4 {
    total += i
}
print(total)
// include the upper bound with ...
total = 0
for i in 0...4 {
    total += i
}
print(total)


// ---- Functions and Closures ---- //
// func to declare a function
// call by passing paramters in parantheses
// use -> followed by the returned type
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person: "Bob", day: "Tuesday")

// the default is to use the paramter name as the label for arguments
// can also have no label: _ paramter: String
// custom label: label paramter: String
func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")

// use a tuple to return multiple values from a function
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }
    return(min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
// access returned tuple by name
print(statistics.min)
// access returned tuple by position (base 0)
print(statistics.2)

// nested functions
// they have access to the vars of outer functions
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

// functions are a "first-class" type
// this means they can return other functions
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

// also, a function can take a function as an argument
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}

var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)

// functions are a special class of "closures"
// closures are blocks of code that can be called later
// they have access to variables and functions available in the scope
// where the closure was created (such as in the nested function example)
numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})

// there are other options for writing closures more concisely
// when a closure's type is already known, the type of the paramters or
//   returned value can be omitted
// (simmilar to list comprehension)
let mappedNumbers = numbers.map({ number in 3 * number })
print(mappedNumbers)

// refer to paramters instead of name
// especially useful for short closures
let sortedNumbers = numbers.sorted(by: { $0 > $1 })
print(sortedNumbers)
// if the closure is the only paramter, parantheses can be omitted entirely
numbers.sorted { $0 > $1 }


// ---- Objects and Classes ---- //
// variabls, constants, methods, functions look identical
class Shape {
    var numberOfSides = 0
    let name = "Bob"
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    func calcPerimeter(_ length: Double) -> Double {
        return Double(numberOfSides) * length
    }
}

// create an instance of the class
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()

// initializers -- every property needs an initial value
class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}
// use `deinit` to deinitialize (cleanup before deallocation) (?)

// subclasses
// explicitly mark overridden methods with `override`
class Square: NamedShape {
    var sideLength: Double
    
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)"
    }
}

let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

class Circle: NamedShape {
    var radiusLength: Double
    
    init(radius: Double, name: String) {
        self.radiusLength = radius
        super.init(name: name)
        numberOfSides = 1
    }
    
    func area() -> Double {
        return 3.14 * radiusLength * radiusLength
    }
    
    override func simpleDescription() -> String {
        return "A circle with a radius of length \(radiusLength)"
    }
}

// property getters and setters
class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0
    
    init (sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }
    
    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        set(newValue) {
            sideLength = newValue / 3.0
        }
    }
    
    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}

var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
triangle.perimeter = 9.9
print(triangle.sideLength)

// `willSet` and `didSet` to update values
class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}

var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)

// optional is classes
let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength


// ---- Enumerations and Structures ---- //

// enumerations
// automatically starts at zero and continues in order
// here, force it to start at 1 and it continues from there
// can also specifically declare the values
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

let ace = Rank.ace
let aceRawValue = ace.rawValue

// expt: a fxn to compare two Rank values by comparing their raw values
func compareRanks(_ rank1: Rank, _ rank2: Rank) -> String {
    if (rank1.rawValue > rank2.rawValue) {
        return "Rank 1 is larger than Rank 2"
    } else if (rank1.rawValue < rank2.rawValue) {
        return "Rank 2 is larger than Rank 1"
    } else {
        return "Both Ranks are equal in value"
    }
}
compareRanks(Rank.ace, Rank.jack)
compareRanks(Rank.three, Rank.two)
compareRanks(Rank.seven, Rank.seven)

//
if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
    print(threeDescription)
}

// a case where the values of a enum do not matter
enum Suit {
    case spades, hearts, diamonds, clubs
    
    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
    
    func color() -> String {
        switch self {
        case .spades, .clubs:
            return "black"
        case .hearts, .diamonds:
            return "red"
        }
    }
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()


// if an enumeration has raw values, those are always the same for every instance
// alternatively, the values can be created upon instantiation
// these behave more like stored properties
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00AM", "8:09PM")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
case let .result(sunrise, sunset):
    print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
case let .failure(message):
    print("Failure... \(message)")
}

// structures
struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())."
    }
}
let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()


// ---- Protocols and Extensions ---- //

