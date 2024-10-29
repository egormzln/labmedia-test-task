//
//  PokemonListViewModel.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 27.10.2024.
//

class PokemonListViewModel {
    private let model: PokemonListModel

    init(model: PokemonListModel) {
        self.model = model
    }

    var limit: Int = 20
    var offset: Int = 0

    var pokemons: [Pokemon] = []

    func fetchPockemons() async {
        do {
            pokemons = try await model.fetchPockemons(limit, offset)
        }
        catch {
            print(error)
            print("Cant get new Pokemons from Pokeapi!")
        }
    }
}
