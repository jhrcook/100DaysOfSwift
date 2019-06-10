// ---- Mutability of Collections ---- //
// depends on assignments as var or const

//arrays
// ordered lists; can be non-unique

// empty arrat
var someInts = [Int]()
print("someInts is of type [Int] with \(someInts.count) items.")

// append to an array
someInts.append(3)
someInts = []  // empty again

// creating an array with a default value
var threeDoubles = Array(repeating: 0.0, count: 3)

// adding arrays
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles

// array literal
var shoppingList: [String] = ["Eggs", "Milk"]
// type inference
var anotherShoppingList = ["Bananas", "Chicken"]

// accessing and modifying arrays
shoppingList.count
shoppingList.isEmpty
shoppingList.append("Flour")
shoppingList += ["Baking Powder"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
// subscript syntax (zero-indexed)
var firstItem = shoppingList[0]
shoppingList[0] = "Six eggs"
shoppingList[4...6] = ["Mango", "Apples"]
// insert at
shoppingList.insert("Syrup", at: 0)
// remove at
let mapleSyrup = shoppingList.remove(at: 0)
firstItem = shoppingList[0]  // gaps are closed after removing a value
// remove last
let apples = shoppingList.removeLast()

// iterating over an array
for item in shoppingList {
    print(item)
}

// to get the index, too
for (index, value) in shoppingList.enumerated() {
    print("Item \(index + 1): \(value)")
}


// ---- Sets ---- //
// unordered and unique values
// the type must be hashable: String, Int, Double, Bool
// Enumeration cases are hashable by default

// create an empty set of type Character
var letters = Set<Character>()
letters.count
letters.insert("a")
letters = []  // empty again

// create a set with an array literal
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
// with type inference
var anotherFavoriteGenres: Set = ["Rock", "Classical", "Hip hop"]

// accessing and modifying a set
favoriteGenres.count
favoriteGenres.isEmpty
// insert (no location)
favoriteGenres.insert("Jazz")

// remove returns an item is it exists, or `nil` if not
if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}

// check it is already exists
favoriteGenres.contains("Funk")

// iterating over a set
for genre in favoriteGenres {
    print("\(genre)")
}

// sorting a set
for genre in favoriteGenres.sorted() {
    print(genre)
}

// ---- Performing Set Operations ---- //
// fundamental set operations
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimes: Set = [2, 3, 5, 7]

// union
oddDigits.union(evenDigits).sorted()

// intersection
oddDigits.intersection(evenDigits).sorted()

// subtraction (set difference)
oddDigits.subtracting(singleDigitPrimes).sorted()

// symmetric difference
oddDigits.symmetricDifference(singleDigitPrimes).sorted()

// set membership and equality
// `==` to determine whether two sets contain all the same values

let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

// subsets, supersets, disjoint (no overlap)
houseAnimals.isSubset(of: farmAnimals)
farmAnimals.isSuperset(of: houseAnimals)
farmAnimals.isDisjoint(with: cityAnimals)


// ---- Dictionaries ---- //
// key (unique, hashable): value pairs
// unordered

