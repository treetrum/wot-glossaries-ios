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

struct Book: Codable {
    let title: String
    let entries: [GlossaryEntry]
}

struct ManifestBook: Codable {
    let name: String
    let data: String
}

struct Manifest: Codable {
    let books: [ManifestBook]
}
