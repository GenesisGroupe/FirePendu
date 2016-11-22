//
//  Word.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation

class Word {
    let value: String
    
    init(_ value: String? = nil) {
        let words = value != nil ? [value!] : Word.computeWords()
        let index = Int(arc4random_uniform(UInt32(words.count)))
        self.value = words[index]
    }
        
    static func computeWords() -> [String] {
        guard let path = Bundle.main.path(forResource: "words", ofType: "txt") else { return [String]() }
        if let data = try? String(contentsOfFile: path, encoding: .utf8) {
            return data.components(separatedBy: .newlines)
        }
        
        return [String]()
    }
}

