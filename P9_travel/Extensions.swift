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
        let charset = CharacterSet.punctuationCharacters.union(CharacterSet.decimalDigits).inverted

        return components(separatedBy: charset).joined()
    }
}
