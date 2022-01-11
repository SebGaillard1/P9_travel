//
//  Extensions.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 27/12/2021.
//

import Foundation

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    var onlyNumbers: String {
        var charset = CharacterSet.decimalDigits
        charset.insert(",")
        charset.insert(".")
        
        charset = charset.inverted
        
        return components(separatedBy: charset).joined()
    }
}
