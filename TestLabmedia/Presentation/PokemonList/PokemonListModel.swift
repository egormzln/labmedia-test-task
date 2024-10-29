//
//  PokemonListView.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 27.10.2024.
//

class PokemonListModel {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func fetchPockemons(_ limit: Int, _ offset: Int) async throws -> [Pokemon] {
        return try await repository.fetchPockemons(limit, offset)
    }
}
