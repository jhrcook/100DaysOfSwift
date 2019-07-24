import UIKit


let password = "12345"
password.hasPrefix("123")
password.hasSuffix("45")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropFirst(suffix.count))
    }
}


let weather = "it's going to rain"
print(weather.uppercased())
print(weather.lowercased())
print(weather.capitalized)


// ---- NSAttributedString ---- //

let string = "This is a test string."
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36),
]

let atrributedString = NSAttributedString(string: string, attributes: attributes)

let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


// challenge 1
extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}

weather.withPrefix("it")
weather.withPrefix("CAT")


// challenge 2

extension String {
    func isNumeric() -> Bool {
        for character in self {
            if Double(String(character)) != nil { return true }
        }
        return false
    }
}
"thisshouldbefalse".isNumeric()
"thisshould9betrue".isNumeric()


// challenge 3
extension String {
    func lines() -> [String] {
        return self.components(separatedBy: "\n")
    }
}
"This is\na multi-\nline statement".lines()
"This is a single line".lines()
