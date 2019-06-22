// ---- Extension Syntax ---- //
// keyword `extension`

// ---- Computed Properties ---- //
// add computed instance/type properties to existing types
// example: make standard unit of length of `Double` as meter
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double {return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters.")

let threeFeet = 3.ft
print("Three feet is \threeFeet) meters.")

let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")


// ---- Initializers ---- //
// add new inits to an existing type
// let an existing type accept your own custom type
// can only add convience inits (not designated inits nor deinits)
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

let defaultRect = Rect()
let memeberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
                           size: Size(width: 5.0, height: 5.0))

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))


// ---- Methods ---- //
// add new instance or type methods
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
3.repetitions {
    print("Hello")
}

// methods from an extension can also modify the instance
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()


// ---- Subscripts ---- //
// add new subscripts
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

89308734759[0]  // first position
89308734759[1]  // second position
89308734759[5]  // sixth position
7472[10]  // beyond end of the integer


// ---- Nested Types ---- //
// add new nested types to existing classes, structs, or enums
extension Int {
    // nested enumeration in `Int`
    enum Kind {
        case negative, zero, positive
    }
    
    // computed variable to assign Kind
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

// a function to print out Kind for a sequence of Int
func printIntegerKind(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        }
    }
}
printIntegerKind([3, 19, -27, 0, -6, 0, 7])
