//
//  Pokemon.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 27.10.2024.
//
//   let pokemon = try? JSONDecoder().decode(Pokemon.self, from: jsonData)

import Foundation

// MARK: - Pokemon

struct Pokemon: Codable {
    let baseExperience: Int
    let forms: [Form]
    let height: Int
    let id: Int
    let name: String
    let order: Int
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case baseExperience = "base_experience"
        case forms, height, id, name, order, sprites, stats, types, weight
    }
}

struct Form: Codable {
    let name: String
    let url: String
}

// MARK: - Sprites

struct Sprites: Codable {
    let other: Other
}

// MARK: - Other

struct Other: Codable {
    let dreamWorld: PokemonImage
    let officialArtwork: PokemonImage

    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case officialArtwork = "official-artwork"
    }
}

// MARK: - PokemonImage

struct PokemonImage: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Stat

struct Stat: Codable {
    let baseStat: Int
    let effort: Int
    let stat: StatDetail

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct StatDetail: Codable {
    let name: String
    let url: String
}

// MARK: - TypeElement

struct TypeElement: Codable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}

// MARK: - PokemonListModel

struct PokemonsList: Codable {
    let count: Int
    let next: String
    let results: [PokemonsListResult]
}

// MARK: - Result

struct PokemonsListResult: Codable {
    let name: String
    let url: String
}
