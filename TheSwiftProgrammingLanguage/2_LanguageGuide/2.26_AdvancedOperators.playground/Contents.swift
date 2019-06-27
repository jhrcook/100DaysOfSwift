// ---- Bitwise Operators ---- //
// manipulate individual raw data bits within a data structure

// bitwise NOT
let initialBits: UInt8 = 0b00001111
let invertedBits = ~initialBits

// bitwise AND
let firstSixBits: UInt8 = 0b11111100
let lasSixBits: UInt8 = 0b00111111
let middleFourBits = firstSixBits & lasSixBits

// bitwise OR
let someBits: UInt8 = 0b10110010
let moreBits: UInt8 = 0b01011110
let combinedBits = someBits | moreBits

// bitwise XOR

let firstBits: UInt8 = 0b00010100
let otherBits: UInt8 = 0b00000101
let outputBits = firstBits ^ otherBits

// bitwise shifts
// shift to left multiples by 2
// shift to right divides by 2
// for unsigned Ints, zeros take the place of emptied spots
let shiftBits: UInt8 = 4  // 00000100
shiftBits << 1  // 00001000
shiftBits << 2  // 00010000
shiftBits << 5  // 10000000
shiftBits << 6  // 00000000
shiftBits >> 2  // 00000001

// get individual components of a color
let pink: UInt32 = 0xCC6699
let redComponent = (pink & 0xFF0000) >> 16
let greenComponent = (pink & 0x00FF00) >> 8
let blueComponent = (pink & 0x0000FF)

// behavior of signed Ints
// the first (most left) bit of an unsigned Int indicated +/- ("sign bit")
// the remaining bits ("value bits") store the actual value

// I have skipped over overflow bits (a bit niche)


// ---- Operator Methods ---- //
// classes and structs can provide their own implementations of operators
// ("operator overloading")
struct Vector2D {
    var x = 0.0, y = 0.0
}

// extend with an implementation of `+`
extension Vector2D {
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector

// extend `-` unary operator (as in "-1")
extension Vector2D {
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
let alsoPositive = -negative

// compound assignement operators: extend `+=`
extension Vector2D {
    static func += (left: inout Vector2D, right: Vector2D) {
        // take advantage of extension for `+` with Vector2D
        left = left + right
    }
}

var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd

// extend equivalence by conforming to `Equatable` protocol
extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
}

let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
    print("These two vectors are equivalent.")
}

// declare Equatable conformance at declaration of the class
// Swift can automatically synthesize equivalance in some circumstances
// here, sinze `x`, `y`, and `z` are all equatable, Swift can figure it out
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}

let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
if twoThreeFour == anotherTwoThreeFour {
    print("These two 3D vectors are also equivalent.")
}


// ---- Custom Operators ---- //
// create my own operators
// example: `+++`

// declare in global level
prefix operator +++

// extend Vector2D: `+++` means to double the instance with itself
extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}

var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled


// can declare precedence and associativity of new operators
// example: `+-` adds `x` values and subtracts `y` values of two Vector2D objs
// belongs to the precedence group `AdditionPrecedence`
infix operator +-: AdditionPrecedence

// extend Vector2D
extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}

let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector


