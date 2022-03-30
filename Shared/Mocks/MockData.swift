//
//  MockData.swift
//  WoT Glossaries (iOS)
//
//  Created by Samuel Davis on 30/3/2022.
//

import Foundation

struct MockData {
    static let books = [
        Book(title: "The Eye of the World", entries: ModelUtils.decodeFromFileName("the-eye-of-the-world", decodable: BookGlossary.self)),
        Book(title: "The Great Hunt", entries: ModelUtils.decodeFromFileName("the-great-hunt", decodable: BookGlossary.self)),
        Book(title: "The Dragon Reborn", entries: ModelUtils.decodeFromFileName("the-dragon-reborn", decodable: BookGlossary.self)),
        Book(title: "The Shadow Rising", entries: ModelUtils.decodeFromFileName("the-shadow-rising", decodable: BookGlossary.self)),
    ]
}
