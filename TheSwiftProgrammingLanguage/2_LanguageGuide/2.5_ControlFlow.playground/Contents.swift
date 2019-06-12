
// ---- For-In loops ---- //
// iterate over a sequence (array, range, string, etc.)

// an array
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}

// key: value pairs of a dict
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs.")
}

// numeric ranges
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

// use an `_` to ignore the value iterated over
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
    answer += base
}
print("\(base) to the power of \(power) is \(answer).")

// adjust the step size of a range
let minutes = 60
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    print(tickMark, separator: "", terminator: " ")
}
for tickMark in stride(from: 0, through: minutes, by: minuteInterval) {
    print(tickMark, separator: "", terminator: " ")
}


// ---- While Loops ---- //
// perform a set of statements until a condition is false
// repeat-while checks the condition at the end

// (the following is an example using "Snakes and Ladders"

// make the game board
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
// ladders
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
// snakes
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08

var square = 0  // start at 0 (just off the board)
var diceRoll = 0
while square < finalSquare {
    // roll the dice
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    // move by the rolled amount
    square += diceRoll
    // check position on board
    if square < board.count {
        square += board[square]
    }
}
print("Game over!")


// repeat-while -- checks the condition at the end
// always performs the code in the loop at least once
square = 0
repeat {
    // check position on the board
    square += board[square]
    // roll the dice
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    // move by the rolled amount
    square += diceRoll
} while square < finalSquare
print("Game over!")


// ---- Conditional Statements ---- //

// if statement
var temperatureFarenheit = 30
if temperatureFarenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
}

// if-else
temperatureFarenheit = 40
if temperatureFarenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else {
    print("It's not that cold. Wear a t-shirt.")
}

// multiple if statements
temperatureFarenheit = 90
if temperatureFarenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else if temperatureFarenheit >= 86 {
    print("It's really warm. Don't forget to wear sunscreen.")
} else {
    print("It's not that cold. Wear a t-shirt.")
}

// switch
// must be exhaustive
// there is no implicit fallthrough
let someCharacter: Character = "z"
switch someCharacter {
case "a":
    print("The first letter of the alphabet.")
case "z":
    print("The last letter of the alphabet.")
default:
    print("Some other character.")
}

// multiple options for a single case
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}

// interval matching
// check a case for their inclusion in an interval
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")

// use tuples to test multiple va;ues in the same switch statement
// the `_` is a wildcard
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside of the box")
default:
    print("\(somePoint) is outside of the box")
}

// temporary value bindings
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}

// "where" clause to check for additional conditions
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

// compound cases (checking for multiple conditions against switch)
// can overflow to the next line
let yetAnotherCharacter = "e"
switch yetAnotherCharacter {
case "a", "e", "i", "o", "u":
    print("\(yetAnotherCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(yetAnotherCharacter) is a consonant")
default:
    print("\(yetAnotherCharacter) is not a vowel nor a consonant")
}

// value binding with compound cases
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an axis, \(distance) from the origin")
default:
    print("Not on an axis")
}


// ---- Control Transfer Statements ---- //
// continue, break, fallthrough, return, throw

// continue
// tells the loop to start again from the top
let puzzleInput = "great minds think alike"
var puzzleOutput = ""
let charactersToRemove: [Character] = ["a", "e", "i", "o", "u", " "]
for character in puzzleInput {
    if charactersToRemove.contains(character) {
        continue
    }
    puzzleOutput.append(character)
}
puzzleOutput

// break
// ends execution of the control flow statement
// can be used in a switch statement essentially as an ignore for the case
let numberSymbol: Character = "三"  // Chinese for 3
var possibleIntegerValue: Int?
switch numberSymbol {
case "1", "١", "一", "๑":
    possibleIntegerValue = 1
case "2", "٢", "二", "๒":
    possibleIntegerValue = 2
case "3", "٣", "三", "๓":
    possibleIntegerValue = 3
case "4", "٤", "四", "๔":
    possibleIntegerValue = 4
default:
    break
}
if let integerValue = possibleIntegerValue {
    print("The integer value of \(numberSymbol) is \(integerValue).")
} else {
    print("An integer value could not be found for \(numberSymbol).")
}


// Fallthrough
// Swift does not naturally fall through a switch statement, but it can be
// done explicitly
// it does not check the next condition's case, just automatically executes
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer"
}

// labeled statements
// (useing the "Snakes and Ladders" example)
// recreate board
board = [Int](repeating: 0, count: finalSquare + 1)
// make ladders
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
// add snakes
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
// reset game play
square = 0
diceRoll = 0


// new rule: must land exactly on the final square
gameLoop: while square != finalSquare {
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
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
print("Game over!")


// ---- Early Exit ---- //
// guard statements must always have an else
// like an if statement with relaxed scoping
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    
    print("Hello \(name)!")
    
    guard let location = person["location"] else {
        print("I hope the weather is nice near your.")
        return
    }
    
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
greet(person: ["name": "John", "location": "Cupertino"])


// ---- Checking API Availability ---- //
// Swift checks that all APIs the code attempts to use are available on the
// device(s) intended to run the code
if #available(iOS 10, macOS 10.12, *) {
    // use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
} else {
    // fall back to ealier iOS and macOS APIs
}
