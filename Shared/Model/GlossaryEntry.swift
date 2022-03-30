//
//  GlossaryEntry.swift
//  wot-glossaries (iOS)
//
//  Created by Samuel Davis on 29/3/2022.
//

import Foundation

struct GlossaryEntry: Codable, Identifiable {
    let id: Int64
    let title: String?
    let titleRaw: String
    let titlePhonetic: String?
    let content: String
}

typealias BookGlossary = [GlossaryEntry]

struct Book {
    let title: String
    let entries: [GlossaryEntry]
}

struct MockData {
    static let shared = MockData()
    
    let books = [
        Book(title: "The Eye of the World", entries: decodeFromFileName("the-eye-of-the-world", decodable: BookGlossary.self)),
        Book(title: "The Great Hunt", entries: decodeFromFileName("the-great-hunt", decodable: BookGlossary.self)),
        Book(title: "The Dragon Reborn", entries: decodeFromFileName("the-dragon-reborn", decodable: BookGlossary.self)),
        Book(title: "The Shadow Rising", entries: decodeFromFileName("the-shadow-rising", decodable: BookGlossary.self)),
    ]
}

func decodeFromFileName<T : Codable>(_ fileName: String, decodable: T.Type) -> T {
    do {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("No data file found: \(fileName)")
        }
        let fileUrl = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: fileUrl)
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("\(error)")
    }
}
