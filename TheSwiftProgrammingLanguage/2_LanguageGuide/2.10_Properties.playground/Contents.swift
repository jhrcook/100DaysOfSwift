// ---- Stored Properties ---- //
// can be variables or constants
// can have a default value or be initialized

struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6
// rangeOfThreeItems.length = 5  // ERROR

// if assign an instance of a struct to a const, cannot change any values
// of the instance, even if they are variables in the struct
// this is because structs are "value types"
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// rangeOfFourItems.firstValue = 6  // ERROR

// lazy stored properties
// a property whose initial value is not calculatged until used
class DataImporter {
    /*
    DataImporter is a class to import data from an external file.
    This class is assumed to take a nontrivial amount of time to initialize.
    */
    var filename = "data.txt"
    // some importing functionality here
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // some data management functionality here
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// the importer var has yet to be initialized

// now it will be initialized
print(manager.importer.filename)


// ---- Computed Properties ---- //
// do not store values
// provide a getter and setter
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y)).")

// shorthand setter declaration
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

// read-only computed properties
// a computed property with a getter but no setter
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")


// ---- Property Observers ---- //

