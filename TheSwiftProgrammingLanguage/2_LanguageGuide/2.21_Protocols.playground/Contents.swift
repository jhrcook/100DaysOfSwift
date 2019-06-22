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


// ---- Adding Protocol Conformance with an Extension ---- //

