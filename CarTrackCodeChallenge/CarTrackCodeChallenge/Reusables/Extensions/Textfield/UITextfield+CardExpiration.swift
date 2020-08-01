//
//  String+CardExpiration.swift
//  SpesheSDKTestConsumer
//
//  Created by WT-iOS on 17/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

extension UITextField {
    
    func cardNumberValidationTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
             // only allow numerical characters
               guard string.compactMap({ Int(String($0)) }).count ==
                   string.count else { return false }

               let text = textField.text ?? ""

               if string.count == 0 {
                   textField.text = String(text.dropLast()).chunkFormatted()
               }
               else {
                   let newText = String((text + string)
                    .filter({ $0 != "-" })) //.prefix(UITextField.CreditCard.totalCardNumberCharacters))
                   textField.text = newText.chunkFormatted()
               }
               textField.sendActions(for: .editingChanged)
               return false
    }
    
    
    
    public func cardExpirationValidationTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text,
            let aRange = Range(range, in: currentText) else { return true }
         
        let updatedText = currentText.replacingCharacters(in: aRange, with: string)
        
        if string == "" {

            if textField.text?.count == 3 {
                textField.text = "\(updatedText.prefix(1))"
                return false
            }

            return true
        }
        
        if updatedText.count == 5
        {
            updatedText.expDateValidation()
            return updatedText.count <= 5
        } else if updatedText.count > 5
        {
            return updatedText.count <= 5
        } else if updatedText.count == 1{
            if updatedText > "1"{
                if updatedText.count < 1 {
                    return true
                } else {
                    textField.text = "0\(updatedText)/"
                    return false
                }
            }
        }  else if updatedText.count == 2{   //Prevent user to not enter month more than 12
            if updatedText > "12"{
                return updatedText.count < 2
            }
        }
        textField.text = updatedText


        if updatedText.count == 2 {

               textField.text = "\(updatedText)/"   //This will add "/" when user enters 2nd digit of month
        }

        return false
    }
}

extension String {
    @discardableResult
    func expDateValidation() -> Bool {

        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enterdYr = Int(suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(prefix(2)) ?? 0  // get first two digit from entered string as month
        print(self) // This is MM/YY Entered by user

        if enterdYr > currentYear
        {
            if (1 ... 12).contains(enterdMonth){
                print("Entered Date Is Right")
                return true
            } else
            {
                print("Entered Date Is Wrong")
                return false
            }

        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth
            {
                if (1 ... 12).contains(enterdMonth) {
                   print("Entered Date Is Right")
                    return true
                }  else
                {
                   print("Entered Date Is Wrong")
                    return false
                }
            } else {
                print("Entered Date Is Wrong")
                return false
            }
        } else
        {
           print("Entered Date Is Wrong")
            return false
        }

    }
}
