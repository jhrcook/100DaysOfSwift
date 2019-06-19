// ---- Setting Initial Values for Stored Properties ---- //

struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
var f = Fahrenheit()
print("The default temperature is \(f.temperature) Fahrenheit")


// ---- Customizing Initialization ---- //
// input parameters, optional property types, assigning constant properties

struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)

// initializers do not have an identifying name
// instead rely upon the paramter names and argument labels

struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)

// use `_` if do not want an argument label
struct Celsius2 {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius:Double) {
        temperatureInCelsius = celsius
    }
}

let bodyTemperature = Celsius2(37.0)


// optional types for optional parameters
class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.response = "Yes"

// define a constant property during itialization
class SurveyQuestion2 {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let beetsQuestion = SurveyQuestion2(text: "How about beets?")
beetsQuestion.ask()
beetsQuestion.response = "I also like beets, but not with cheese."


// ---- Default Initializers ---- //
// Swift creates a default init for any struct or class that has default
// values and no init function
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()
item.name

// memberwise initializers for structs
struct Size {
    var width = 0.0
    var height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)


// ---- Initializer Delegation for Value Types ---- //
// can have multiple initializers and initializers can call other initializers
// within a type
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// using empty initializer (structure with default values)
let basicRect = Rect()
// using init(origin:size:)
let originRect = Rect(origin: Point(x: 2.0, y: 2.0),
                      size: Size(width: 5.0, height: 5.0))
// using init(center:size:)
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))


// ---- Class Inheritance and Initialization ---- //
// "designatd initializers" - fully initializes all properties of the class and
//    calls an approriate superlass initializer to continue up the chain
// "convenience initializaers" - seccondary/supporting initializers; use
//    whenever a shortcut to a common initialization pattern will save time or
//    make the intent clearer

class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

let vehicle = Vehicle()
print("Vehicle: " + vehicle.description)

class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}

let bicycle = Bicycle()
print("Bicycle: " + bicycle.description)

class Hoverboard: Vehicle {
    var color: String
    init(color: String) {
        self.color = color
        // super.init() implicitly called here
    }
    override var description: String {
        return "\(super.description) in a beautiful \(color)"
    }
}

let hoverboard = Hoverboard(color: "silver")
print("Hoverboard: " + hoverboard.description)

// example of designated and conenience initializers
class Food {
    var name: String
    // a designated initializer
    init(name: String) {
        self.name = name
    }
    // a convenience initializer
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

let namedMeat = Food(name: "Bacon")
let mysteryMeat = Food()
mysteryMeat.name

class RescipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

let oneMysteryItem = RescipeIngredient()
let oneBacon = RescipeIngredient(name: "Bacon")
let sizEggs = RescipeIngredient(name: "Eggs", quantity: 6)

class ShoppingListItem2: RescipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name) "
        output += purchased ? "✓" : "𐄂"
        return output
    }
}

var breakfastList = [
    ShoppingListItem2(),
    ShoppingListItem2(name: "Bacon"),
    ShoppingListItem2(name: "Eggs", quantity: 6)
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}


// ---- Failable Initializers ---- //
// create an optional type if conditions of the initialization can fail

let wholeNumber: Double = 12345.0
let pi = 3.14

if let valueMaintained = Int(exactly: wholeNumber) {
    print("\(wholeNumber) conversion to Int maintains value of \(valueMaintained)")
}

let valueChanged = Int(exactly: pi)

if valueChanged == nil {
    print("\(pi) conversion to Int does not maintain value")
}

struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

let someCreature = Animal(species: "Giraffe")
if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}

let anonymousCreature = Animal(species: "")
if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
}

// failable initializers for enums
enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}

let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded")
}

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed")
}

// enums with raw values automatically recieve a failable initializer with
// the argument label `rawValue`
enum TemperatureUnit2: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}

let fahrenheitUnit2 = TemperatureUnit2(rawValue: "F")
if fahrenheitUnit2 != nil {
    print("This is a defined temperature unit, so initialization succeeded")
}

let unknownUnit2 = TemperatureUnit2(rawValue: "X")
if unknownUnit2 == nil {
    print("This is not a defined temperature unit, so initialization failed")
}

// failable initializers can delegate across to another failable initializer
// within the same type
// failable initializers of a subclass can delegate to a superclass
// failable initializers can also delegate to non-failable initializers (usefull)
// for setting a default state)

class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}

// with both name and quantity
if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item \(twoSocks.name), quantity: \(twoSocks.quantity)")
}

// fail with quantity < 1
if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}

// fail with name.isEmpty
if let oneUnnamed = CartItem(name: "", quantity: 1) {
    print("Item \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
    print("Unable to initalize one unnamed product")
}


// overriding a failable initializer
class Document {
    var name: String?
    init() {}
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
// this subclass overrides both initializers in parent
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            // default to "[Untitled]" instead of `nil`
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

// force unwrap in an initializer to call a failable init in the superlcass
// in a nonfailable init in the subclass
class UntitleDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}


// ---- Required initializers ---- //
// an init that must be implemented by every subclass
class SomeClass {
    required init() {
        // initializer implementation goes here
    }
}
class SomeSubclass: SomeClass {
    required init() {
        // subclass implementation of the required init goes here
    }
}


// ---- Setting a Default Property Value with a Closure or Function ---- //
// use a closure or global func to provide a customized value for a property

// example: Chessboard models a board for the game of chess (8 x 8 squares)
struct Chessboard {
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return(boardColors[(row * 8) + column])
    }
}

let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))
print(board.squareIsBlackAt(row: 7, column: 7))
