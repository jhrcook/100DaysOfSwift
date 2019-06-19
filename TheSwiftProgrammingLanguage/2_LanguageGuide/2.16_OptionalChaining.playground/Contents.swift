// ---- Optional Chaining as an Alternative to Forced Unwrapping ---- //
// can use `?` like `!` for force unwrapping, but fails gracefully by
// always transforming the returned type to an optional: `Int` to `Int?`
class Person {
    var residence: Residence?
}
class Residence {
    var numberOfRooms = 1
}

let john = Person()

// with force unwrapping:
// let roomCount = john.residence!.numberOfRooms // ERROR

// with optoinal chaining
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) rooms(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

john.residence = Residence()

if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) rooms(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}


// ---- Defining Model Classes for Optional Chaining ---- //
// multilevel optional chaining to go deep into properties, methods, subscripts
class Person2 {
    var residence: Residence2?
}

class Residence2 {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}

let johnny = Person2()
if let roomCount = johnny.residence?.numberOfRooms {
    print("Johnny's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrive the number of rooms.")
}

let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
johnny.residence?.address = someAddress
// address is not assigned because `residence` is still `nil`

func createAddress() -> Address {
    print("Function was called.")
    
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    return someAddress
}
johnny.residence?.address = createAddress()
// "Function was called." is not printed because the function is not evaluated
// since the optional chaining failed because `residence` is `nil`


// ---- Call Methods Through Optional Chaining ---- //
// call a method on an optional value using optional chaining
// even if the method does not normally return anything -- can still check
//   if it returned `nil`
if johnny.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}

// can also check the results of setting a variable
if (johnny.residence?.address = someAddress) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
}


// ---- Accessing Subscripts Through Optional Chaining ---- //
// can try to retrieve or set a subscript value
if let firstRoomName = johnny.residence?[0].name {
    print("the first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}

johnny.residence?[0] = Room(name: "Bathroom")

let johnsHouse = Residence2()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
johnny.residence = johnsHouse

if let firstRoomName = johnny.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}


// if a subscript returns a value of optional type, place a question mark AFTER
// the subscript
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72  // `nil` --> no assignment
print(testScores)


// ---- Linking Multiple Levels of Chaining ---- //
// example with two levels of optional chaining

// fails
if let johnsStreet = johnny.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the street name.")
}

// now add an Address
let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
johnny.residence?.address = johnsAddress

// succeeds
if let johnsStreet = johnny.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the street name.")
}


// ---- Chaining on Methods with Optional Return Values ---- //
// optional chaining on the return object of a method
if let buildingIdentifier = johnny.residence?.address?.buildingIdentifier() {
    print("Johnny's building identifier is \(buildingIdentifier).")
}

if let beginsWithThe = johnny.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("Johnny's house building identifier begins with \"The\".")
    } else {
        print("Johnny's house building identifier does not begin with \"The\".")
    }
}
