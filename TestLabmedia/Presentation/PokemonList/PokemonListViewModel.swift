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

    var limit: Int = 10
    var offset: Int = 0

    // <id>: <pokemon>
    var pokemonsData: [Int: Pokemon] = [:]

    var defaultPokemonsList = [Pokemon]()
    var filteredPokemonsList = [Pokemon]()

    var isSearchActive = false
    var isFilterActive = false

    var isLoadingData = false

    func loadMoreData() async {
        offset += limit
        await fetchPockemons()
    }

    func updateDefaultPokemonsList() {
        defaultPokemonsList = pokemonsData.keys.sorted().compactMap {
            pokemonsData[$0]
        }
    }

    func fetchPockemons() async {
        isLoadingData = true
        do {
            let newPokemons: [Pokemon] = try await model.fetchPockemons(limit, offset)
            for pokemon in newPokemons {
                pokemonsData[pokemon.id] = pokemon
            }
        } catch {
            print(error)
            print("[debug] Cant get new Pokemons from Pokeapi!")
        }
        updateDefaultPokemonsList()
        isLoadingData = false
    }

    func searchPokemons(_ searchText: String) {
        let allPokemons = Array(pokemonsData.values)

        if let searchId = Int(searchText) {
            filteredPokemonsList = allPokemons.filter { pokemon in
                pokemon.id == searchId
            }
        } else {
            filteredPokemonsList = allPokemons.filter { pokemon in
                pokemon.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func filterPokemons(by filter: PokemonFilter) {
        let allPokemons = Array(pokemonsData.values)

        switch filter {
            case .id:
                isFilterActive = false
                filteredPokemonsList = allPokemons.sorted(by: { $0.id < $1.id })
            case .name:
                isFilterActive = true
                filteredPokemonsList = allPokemons.sorted(by: { $0.name < $1.name })
        }
    }
}

enum PokemonFilter: String {
    case id = "By ID"
    case name = "By name"

    static func byID(_ id: Int) -> PokemonFilter {
        switch id {
            case 0:
                return PokemonFilter.id
            case 1:
                return PokemonFilter.name
            default:
                return PokemonFilter.id
        }
    }
}
