//
//  String+.swift
//  InstantMac
//
//  Created by Paul Sevilla on 19/03/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import Foundation
import UIKit

extension String {
  
  var firstUppercased: String {
    guard let first = first else { return "" }
    return String(first).uppercased() + dropFirst()
  }
  
  var isNumeric: Bool {
      return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
  }
  
  var numericOnly: String {
    return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
  }
    
  var numericAndSpaceOnly: String {
    var allowedCharacters = CharacterSet.decimalDigits.inverted
    allowedCharacters.insert(charactersIn: " ")
    return components(separatedBy: allowedCharacters).joined()
  }
  
  var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var nullifiedIfEmpty: String? {
    return isEmpty ? nil : self
  }
  
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
  
  var utf8Encoded: Data {
    return data(using: .utf8)!
  }
  
  var possessiveForm: String {
    if let lastChar = last, String(lastChar) == "s" {
      return self + "'"
    }
    return self + "'s"
  }
  
  var byAddingHTTPPrefixIfNeeded: String {
    if self.hasPrefix("http://") || self.hasPrefix("https://") {
      return self
    } else {
      return "http://" + self
    }
  }
  
  var withoutHtmlTags: String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with: "", options:.regularExpression, range: nil)
  }
  
//  static func url(_ route: TargetType) -> String {
//    return route.baseURL.appendingPathComponent(route.path).absoluteString
//  }

    var arePasswordCharacters: Bool {
        let regex = "^(?=.*\\d)(?=.*[A-Za-z])[0-9a-zA-Z!@#$%^&*()-_=+{}|?>.<,:;~`’]{8,}$"
        let validation = NSPredicate(format: "SELF MATCHES %@", regex)
        return validation.evaluate(with: self)
    }
    
    public var arePasswordCharacters2: Bool {
        // 1 lower, 1 upper, 1 number, 1 symbol
        //let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~])[A-Za-z\\d !\"\\\\#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~]{8,}"
        //safe to escape all regex chars
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    private static var emailRegex: NSPredicate = {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        return NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    }()
    
    func isEmailFormatValid() -> Bool {
        return String.emailRegex.evaluate(with: self)
    }
    
    var containsSymbols: Bool {
        if count > 0 {
            let allowedCharacters = CharacterSet.punctuationCharacters
            guard let _ = rangeOfCharacter(from: allowedCharacters) else { return false }
            return true
        }
        
        return false
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func showFirstDigits(count: Int = 4 ) -> String {
        let cardNumber = self
        let firstDigits = String(cardNumber[0...count-1])
        let requiredMask = String(repeating: "*", count: cardNumber.count - firstDigits.count)
        let maskedString = "\(firstDigits)\(requiredMask)"

        return maskedString.chunkFormatted(withChunkSize: count, withSeparator: " ")
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let startPos = self.distance(from: startIndex, to: range.lowerBound)
        let endPos = distance(from: startIndex, to: range.upperBound)
        return NSRange(location: startPos, length: endPos - startPos)
    }
    
    func fullrange() -> NSRange {
        return NSRange(location: 0, length: self.count)
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

//extension String: LocalizedError {
//
//    public var localizedDescription: String { return self }
//}

extension Collection {
    public func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
                        withSeparator separator: String = "-") -> String {
        
        return filter { "\($0)" != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
        
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension Dictionary {
    
    func toJSON() -> String? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: jsonData,
                   encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension String {
    static var formatterDecimalAndCommas: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var commaWithDecimals: NSNumber? {
        return String.formatterDecimalAndCommas.number(from: self.replacingOccurrences(of: String.formatterDecimalAndCommas.groupingSeparator, with: ""))
    }
}

extension String {
  mutating func insert(string:String,ind:Int) {
    self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
  }
}
