//
//  CardStorage.swift
//  Freshzilla
//
//  Created by ramsayleung on 2024-03-31.
//

import Foundation

class CardStorage {
    static let savePath = URL.documentsDirectory.appending(path: "savedCards")
    static func loadData() -> [Card] {
        do {
            let data = try Data(contentsOf: savePath)
            return try JSONDecoder().decode([Card].self, from: data)
        } catch {
            return []
        }
    }
    
    static  func saveData(cards: [Card]) {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePath)
        }catch {
            print("Unable to save data.")
        }
    }
}
