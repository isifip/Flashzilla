//
//  Card.swift
//  Flashzilla
//
//  Created by Irakli Sokhaneishvili on 12.01.22.
//

import Foundation


struct Card: Codable, Identifiable {
    var id = UUID()
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who Played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
