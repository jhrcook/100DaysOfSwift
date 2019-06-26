// ---- ARC in action ---- //
// example of ARC  with class `Person` with constant property `name`
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized.")
    }
    deinit {
        print("\(name) is being deinitialized.")
    }
}

// three references to a `Person?` instance
var reference1: Person?
var reference2: Person?
var reference3: Person?

// asign to all same instance of a Person (passed by reference)
reference1 = Person(name: "John Appleseed")
reference2 = reference1
reference3 = reference1

// break the storng references to 2 of 3 (not deinitialized, yet)
reference1 = nil
reference2 = nil

// break final strong reference --> deinit
reference3 = nil


// ---- Strong Reference Cycles Between Class Instances ---- //
// "strong reference cycle": when two class instances hold a strong reference
//    to each other
// resolved by defining relationaships as weak or unownded referecnes
// example of a strong reference cycle:
// Apartment` models a block of apartments and its residents
class Person2 {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being dinitialized.") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person2?
    deinit { print("Apartment \(unit) is being deinitialized.") }
}

var john: Person2?
var unit4A: Apartment?

john = Person2(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

// create a strong reference cycle
john!.apartment = unit4A
unit4A!.tenant = john

// sets the variable names to nil, but the objects are still initialized
// and have pointers to each other
john = nil
unit4A = nil


// ---- Resolving Strong Reference Cycles Between Class Instances ---- //
// weak reference: when other instance has a shorter lifetime
// unowned: when the other instance has the same/longer lifetime


// example using `weak` references (all names are suffixed with `3`)
class Person3 {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment3?
    deinit { print("\(name) is being dinitialized.") }
}

class Apartment3 {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person3?
    deinit { print("Apartment \(unit) is being deinitialized.") }
}

var john3: Person3?
var unit4A3: Apartment3?

john3 = Person3(name: "John Appleseed")
unit4A3 = Apartment3(unit: "4A")

// create a strong reference cycle
john3!.apartment = unit4A3
unit4A3!.tenant = john3

// sets the variable names to nil, but the objects are still initialized
// and have pointers to each other
john3 = nil
unit4A3 = nil

// example with unowned references
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) { self.name = name }
    deinit { print("\(name) is being deinitialized")}
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var james: Customer?
james = Customer(name: "James Pineappleseed")
james!.card = CreditCard(number: 1234_5678_9012_3456, customer: james!)

// deinitializes both `james` and the `CreditCard` instance in `james.card`
james = nil


// ---- Unownded References and Implicitly Unwrapped Optional Properties ---- //
// third scenario where both properties will always have a value once init
// is useful to have one as an unowned property and the other an implicitly
//   unwrapped optional property in the other
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name).")


// ---- Strong Reference Cycles for Closures ---- //
// when a closure to a property of a class calls self or a method
// fix the cycle with a "closure capture list"

// example of how this type of cycle can form
class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit { print("\(name) is being deinitialized") }
}

// because `asHTML` is a closure, not a method, it can redefined
let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

// neither the `paragraph` nor its asHRML closure are deallocated
paragraph = nil


// ---- Resulving Strong Reference Cycles for Closures ---- //
// "capture list" - defines rules to use when capturing one or more reference
//   types within the closure's body

class HTMLElement2 {
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var paragraph2: HTMLElement2? = HTMLElement2(name: "p", text: "hello, world")
print(paragraph2!.asHTML())

// now paragraph2 can deinit
paragraph2 = nil
