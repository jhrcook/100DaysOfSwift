// ---- Enumeration Syntax ---- //
// syntax
enum SomeEnumeration {
    // enumeration definition goes here
}

// example: points of a compass
enum CompassPoint {
    case north
    case south
    case east
    case west
}

// example: planets
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west
directionToHead = .east

// ---- Matching Enumeration Values with a Swith Statement ---- //
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for the penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
// this is exhaustive since it covers the entire enum

let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}


// ---- Iterating over Enumeration Cases ---- //
// `CaseIterable` allows use of `enum.allCases`
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count

for beverage in Beverage.allCases {
    print(beverage)
}


// ---- Associated Values ---- //
// values assigned to the cases
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

// can check the associated values in a switch-case statement
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}

// if all are extracted as a variable or constant, can declare out front
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}


// ---- Raw Values ---- //
// cases in an enum can come with predefined values
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}


// Implicitly assigned raw values: can let Swift automatically assign values

// give all cases an Int value, starting at 0 by default
// provide the first value, Swift will start there
enum Planet2: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

// default values of type string are just the case name
enum CompassPoint2: String {
    case north, south, east, west
}
let earthsOrder = Planet2.earth.rawValue
let sunsetDirection = CompassPoint2.west.rawValue

// initializing from a raw value
// i.e.: "call" the enumeration by the raw value
// if doesn't exist, returns `nil` (thus, always returns an optional)
let possiblePlanet = Planet2(rawValue: 7)
// possible planet is of type `Planet?`

let positionToFind = 11
if let somePlanet = Planet2(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans.")
    }
} else {
    print("There isn't a planet at position\(positionToFind).")
}


// ---- Recursive Enumerations ---- //
// has another instance of the enumeration as the associated value for one or
// more of the enumeration cases
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

// if all cases are recursive
indirect enum ArithmeticExpression2 {
    case number(Int)
    case addition(ArithmeticExpression2, ArithmeticExpression2)
    case multiplication(ArithmeticExpression2, ArithmeticExpression2)
}

// (5 + 4) * 2
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

// work well for operations that are naturally recursive
func evalutate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evalutate(left) + evalutate(right)
    case let .multiplication(left, right):
        return evalutate(left) *  evalutate(right)
    }
}
