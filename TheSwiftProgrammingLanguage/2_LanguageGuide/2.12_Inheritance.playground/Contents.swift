// ---- Defining a Base Class ---- //
// base class: any class that does not inherit from another class

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do nothing - an arbitrary vehicle does not necessarily make noise
    }
}

let someVehicle = Vehicle()
print("Vehicle: " + someVehicle.description)


// ---- Subclassing ---- //
// basing a new class on an existing class

class Bicycle: Vehicle {
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0
print("Bicycle: " + bicycle.description)

class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: " + tandem.description)


// ---- Overriding ---- //
// a subclass can provide its own implementation of a method, property, or
// subscript that it would otherwise inherit

// must use `override` keyword

// can access the method, property, or subscript of the superclass by
// using `super.nameOfMethod()`, `super.nameOfProperty`, or `super[index]`

class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

let train = Train()
train.makeNoise()

// overriding properties to add/modify getters and setters
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: " + car.description)

// override of property observers
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: " + automatic.description)


// ---- Preventing Overrides ---- //
// prevent a method, property, or subscript from being overriden by marking
// it as `final` in the super class

