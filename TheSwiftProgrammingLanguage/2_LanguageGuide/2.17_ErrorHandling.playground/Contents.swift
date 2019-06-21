// ---- Representing and Throwing Errors ---- //
// correspond to the Error protocol

// example with enums
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

// `throw` to throw an error
//throw VendingMachineError.insufficientFunds(coinsNeeded: 5)


// ---- Handling Errors ---- //
// there are 4 error handling method in Swift (described below

// 1) propogating errors: a function can throw an error to the scppe that
//   called it
struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name).")
    }
}

// vend(itemNamed:) can throw and must be called using either `try` `do-catch`
//   or further propogate the error

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels"
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

// throwing initializers work just like throwing functions
struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

// 2) do-catch: handle errors by running a block of code
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection")
} catch  VendingMachineError.outOfStock {
    print("Out of Stock")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert and additional \(coinsNeeded) coins")
} catch {
    print("Unexpected error: \(error)")
}

// if error is not handled by do-catch, gets propogated to outside scope
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Invalid selection, out of stock, or not enough money.")
    }
}
do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error).")
}

// 3) convert error to optional values
// in the below example, `x` and `y` have the exact same value (`Int?`) and
//   same behavior
func someThrowingFunction() throws -> Int {
    return 1
}
let x = try? someThrowingFunction()
let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}

// 4) assert an error will not be thrown: `try!`
let z = try! someThrowingFunction()


// ---- Specifying Cleanup Actions ---- //
// use `defer` to run code just before execution leaves the current code block
func exampleOfDefer() {
    var phrase = "Hello "
    defer {
        // executes last
        phrase += "friend!"
        print(phrase)
    }
    phrase += "there, "
    // now run `defer { ... }`
}
exampleOfDefer()
