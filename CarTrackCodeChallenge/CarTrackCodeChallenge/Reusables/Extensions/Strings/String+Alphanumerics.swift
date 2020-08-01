//
//  String+Alphanumerics.swift
//  InstantMac
//
//  Created by Vic on 18/10/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import Foundation

extension String {
    
    private static var formatterDecimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var floatValue: Float? {
        return String.formatterDecimal.number(from: self)?.floatValue
    }
    
  var isAlphaNumerics: Bool {
    if count > 0 {
      let allowedCharacters = CharacterSet.alphanumerics
    
      let unwantedStr = trimmingCharacters(in: allowedCharacters)
      return unwantedStr.count == 0
    }
    
    return true
  }
    
    
    var containsLettersAndNumbers: Bool {
        if count > 0 {
            var allowedCharacters = CharacterSet.decimalDigits
            guard let _ = rangeOfCharacter(from: allowedCharacters) else { return false }
            
            allowedCharacters = CharacterSet.letters
            guard let _ = rangeOfCharacter(from: allowedCharacters) else { return false }
            return true
        }

        return false
    }
  
  var isAlphaNumericsAlsoSpace: Bool {
    if count > 0 {
      var allowedCharacters = CharacterSet.alphanumerics
      allowedCharacters.insert(charactersIn: " ")
      
      let unwantedStr = trimmingCharacters(in: allowedCharacters)
      return unwantedStr.count == 0
    }
    
    return true
  }
}
