//
//  Card.swift
//  Freshzilla
//
//  Created by ramsayleung on 2024-03-28.
//

import Foundation

struct Card: Codable, Identifiable, Hashable {
    var id = UUID()
    var prompt : String
    var answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who", answer: "Jodie Whittaker")
}
