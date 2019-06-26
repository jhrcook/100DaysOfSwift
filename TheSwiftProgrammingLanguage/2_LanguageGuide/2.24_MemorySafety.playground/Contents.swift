// ---- Understanding Conflicting Accress to Memory ---- //
// write access
var one = 1
// read access
print("We're number \(one)!")

// instantaneous memory access (most accessess)
func oneMore(than number: Int) -> Int {
    return number + 1
}

var myNumber = 1
myNumber = oneMore(than: myNumber)
print(myNumber)


// ---- Conflicting Access to In-Out Paramters ---- //
// a function has long-term write access to all of its in-out params
// cannot access the original variable even if scoping rules would normally
//   permit it
var stepSize = 1
func increment(_ number: inout Int) {
    number += stepSize
}
// increment(&stepSize)  // run-time error!

// solution: create explicit copy of stepSize
var copyOfStepSize = stepSize  // passed by value (not reference)
increment(&copyOfStepSize)

// because of long-term write access to in-out params: passing a single
// argument as the argument for multiple in-out params in the same func
func balance(_ x: inout Int ,_ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y =  sum - x
}

var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)  // OK
// balance(&playerOneScore, &playerOneScore)  // run-time error!


// ---- Conflicting Access to self in Methods ---- //
// a mutating method of a struct has write access to `self`
struct Player {
    var name: String
    var health: Int
    var energy: Int
    
    static let maxHealth = 10
    
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)

oscar.shareHealth(with: &maria)  // OK
// oscar.shareHealth(with: &oscar)  // run-time error


// ---- Comflicting Access to Properties ---- //
// for value types (structs, enums, tuples) changing one property requires write
//   access to entire value

// example with a tuple
var playerInformation = (health: 10, energy: 20)
// balance(&playerInformation.health, &playerInformation.energy)  // run-time error

// example in a struct
var holly = Player(name: "Holly", health: 10, energy: 10)
// balance(&holly.health, &holly.energy)  // run-time error

// this isn't a problem if the `holly` variable was local
// the compiler can prove that these values do not interact
func someFunction() {
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    balance(&oscar.health, &oscar.energy)  // OK
}
