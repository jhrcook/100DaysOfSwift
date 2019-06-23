// ---- Property Requirements ---- //
// can dictate is a property is to be gettable and/or settable

// simple example:
protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}

let john = Person(fullName: "John Appleseed")
john.fullName

// larger class conforming to `FullyNamed` protocol
// `fullName` is a computer property still of type `String`
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName


// ---- Method Requirements ---- //
// look just like normal methods, except cannot have default values
protocol RandomNumberGenerator {
    func random() -> Double
}
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And another one: \(generator.random())")


// ---- Mutating Method Requirements ---- //
// allow a method to mutate the instance by marking with `mutating`
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()


// ---- Initializer Requirements ---- //
// protocols can require the presence of certain initializers
// look pretty similiar to normal init statements
// failable inits are allowed


// ---- Protocols as Types ---- //
// protocols are fully fleged types
// can use as paramters/ return type, const/var/property type,
//   type in arrays/dicts
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator

    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }

    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll()).")
}


// ---- Delegation ---- //
// delegation allows a class/struct to hand off a responsibility to an
//   instance of another type
// a protocol encapsulates the reponsibility to ensure the other process
//   provides the necessary functionality
protocol DiceGame {
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate: AnyObject {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartWithNewTurnWtihDiceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

// example of snakes-and-ladders game that conforms to `DiceGame`
// notifies `DiceGameDelegate` about the progress of the game
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    weak var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartWithNewTurnWtihDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders.")
        }
        print("The game is using a \(game.dice.sides)-sided dice.")
    }
    
    func game(_ game: DiceGame, didStartWithNewTurnWtihDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll).")
    }
    
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns.")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()


// ---- Adding Protocol Conformance with an Extension ---- //
// extend an existing type to adopt and coform to a new protocol
// example: new protocol
protocol TextRepresentable {
    var textualDescription: String { get }
}
// extend `Dice` class
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)

// extend `SnakesAndLadders`
extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares."
    }
}
print(game.textualDescription)


// conditionally conforming to a protocol - when a generic type may only
//   satisfy the requirements of a protocol under certain conditions
extension Array: TextRepresentable where Element: TextRepresentable {
     var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ",") + "]"
    }
}
let myDice = [d6, d12]
print(myDice.textualDescription)

// use an empty extension if a type already conforms to a protocol
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}
let simonTheHamster = Hamster(name: "Simon")
let someTextRepresentable: TextRepresentable = simonTheHamster
print(someTextRepresentable.textualDescription)


// ---- Collections of Protocol Types ---- //
// can declare a protocol as the type to be stored in a collection
let things: [TextRepresentable] = [game, d12, simonTheHamster]
for thing in things {
    print(type(of: thing))
    print(thing.textualDescription)
}


// ---- Protocol Inheritance ---- //
// a protocol can inherit from another protocol
// syntax is similar to classes and subclasses
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
// extend `SnakesAndLadders` to conform to`PrettyTextRepresentable`
extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "🔺 "
            case let ladder where ladder < 0:
                output += "🔻 "
            default:
                output += "o "
            }
        }
        return output
    }
}
print(game.prettyTextualDescription)


// ---- Class-Only Protocols ---- //
// limit protocol adoption to only classes
protocol SomeClassOnlyProtocol: AnyObject {
    var someProperty: String { get }
}


// ---- Protocol Composition ---- //
// combine multiple protocols into a single requirement
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person2: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age).")
}
let birthdayPerson = Person2(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)

// combine `Named` protocol with `Location` class
class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}

func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)


// ---- Checking for Protocol Conformance ---- //
// use `is` and `as` to check for protocol conformance
protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.14
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius}
}

class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}

class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4),
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area).")
    } else {
        print("Something that does not have area.")
    }
}


// ---- Optional Protocol Requirements ---- //
// [made for interoperability with Objective-C]
// the type automatically becomes an optional (and can be used with chaining)

import Foundation

@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

// implementation of the `CounterDataSource` protocol
class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

// a more complex example of `CounterDataSource`
class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}


// ---- Protocol Extensions ---- //
//
