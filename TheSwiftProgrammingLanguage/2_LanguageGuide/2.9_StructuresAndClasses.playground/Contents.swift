// ---- Comparing Structures and Classes ---- //
// in general, prefer structures and only use classes when necessary

// definition syntax
struct SomeStructure {
    // structure def goes here
}
class SomeClass {
    // class def goes here
}

// example struct
struct Resolution {
    var width = 0
    var height = 0
}
// example class
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

// struct and class instances
let someResolution = Resolution()
let someVideoMode = VideoMode()

// accessing properties using dot syntax
print("The width of someResolution is \(someResolution.width).")
print("The width of someVideoMode is \(someVideoMode.resolution.width).")

// memberwise intializaers for structs
// all structs have an automatically generated memberwise intializer
let vga = Resolution(width: 640, height: 480)

// ---- Structures and Enumerations Are Value Types ---- //
// a value type is a type whose value is copied when assigned to a variable
// or constant or passed to a fxn

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
// `cinema` is a copy of `hd`
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide.")
print("hd is still \(hd.width) pixels wide.")

// same behavior applies to enums
enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() {
        self = .north
    }
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print("The current direction is \(currentDirection).")
print("The remembered direction is \(rememberedDirection).")


// ---- Classes Are Reference Types ---- //
// reference types are NOT copied when passed
// rather, they pass a reference

let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The freameRate property of tenEighty is now \(tenEighty.frameRate).")

// identity operators
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
