// ---- Constants and Variables ---- //
let maximumNumberOfLoginAttempts = 10
var currentLoginAttempts = 0
var x = 0.0, y = 0.0, z = 0.0

// type annotation
var welcomeMessage: String
welcomeMessage = "Hello"

// declare types of multiple new vars at once
var red, green, blue: Double

// variables CAN change value
var friendlyWelcome = "Hello!"
friendlyWelcome = "Bonjour!"
// constants CANNOT change value
let languageName = "Swift"
//languageName = "Swift++"  // ERROR

// printing
print(welcomeMessage, friendlyWelcome, separator: " - ", terminator: " -- Goodbye!")
//string interpolation
print("\(friendlyWelcome) my good friend!")

// ---- Comments ---- //
/*
 multi-line comments
*/
/*
You can
 /*
  nest
 */
 multi-line comments
*/
// useful for commenting out code that has code blocks


// ---- Integers ---- //
// whole numbers
// signed or unsigned (non-negative)
// 8, 16, 32, 64 bit integers
let smallPositiveNum: UInt8 = 8
let largeNegativeNum: Int32 = 100000001
// integer bounds
let minValue = UInt8.min
let maxValue = UInt8.max
// `Int`,`UInt` adapts to the platform (safest option)
let systemIntMax = Int.max


// ---- Floating-Point Numbers ---- //
// with fractional componnents (decimals)
// Double (64-bit) has precision of at least 15 decimal digits (preferred)
// Float (32-bit) has precision of at least 6 decimal digits


// ---- Type Safety and Type Inference ---- //
// inferred to be an Int
let meaningOfLife = 42
// inferred to be a Double
let pi = 3.14
// inferred to be a Double
let anotherPi = 3 + 0.14


// ---- Numeric Literals ---- //
// decimal: no prefix
let decimalInteger = 17
// binary: `0b` prefix
let binaryInteger = 0b10001
// octal: `0o` prefix
let octalInteger = 0o21
// hexadecimal = `0x` prefix
let hexadecimalInteger = 0x11

// exponents (`e` or `E`)
let someExponent = 1.25e5
let anotherExponent = 1.25e-5

// optional formating for easier reading
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1


// ---- Numeric Type Conversion ---- //
// convert by initializing a new number of the desired type with the old one
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)

// integer and floating point conversions
let three = 3
let piDecimals = 0.14
let piAdd = Double(3) + piDecimals
let piInteger = Int(piAdd)

// floating points are *truncated* not rounded
let four = Int(4.9)
let negativeThree = Int(-3.9)


// ---- Type Aliases ---- //
// refer to an existing type by another name
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.max


// ---- Booleans ---- //
let orangesAreOrange = true
let turnipsAreDelicious = false
// used in conditionals
if turnipsAreDelicious {
    print("Mmm, tasty turnips.")
} else {
    print("Eww, turnips are horrible.")
}

// Swift's type safety completely separates numerics and booleans
// therefore, 1 != `true` and `Bool(1)` is an type error, not conversion to `true`


// ---- Tuples ---- //
// group multiple values into a single compound value
// the values can be of any and multiple types
let http404Error = (404, "Not Found")

// decompose the tuple into individual elements
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode).")
print("The status message is \(statusMessage).")

// elements can be ignored using `_`
let (justTheStatusCode, _) = http404Error

// individual elements can be accessed by indexing
print("The status code is \(http404Error.0).")
print("The status message is \(http404Error.1).")

// elements can be named and accessed by name
let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode).")
print("The status message is \(http200Status.description).")


// ---- Optionals ---- //

