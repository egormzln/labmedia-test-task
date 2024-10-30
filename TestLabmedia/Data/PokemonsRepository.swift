//
//  PokemonRepository.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 27.10.2024.
//

import Foundation

protocol PokemonRepositoryProtocol {
    func fetchPockemons(_ limit: Int, _ offset: Int) async throws -> [Pokemon]
}

class PokemonRepository: PokemonRepositoryProtocol {
    enum PokeapiErrors: Error {
        case invalidUrl
        case invalidResponse
        case cantDecodePokemonsList
    }
    
    func fetchPockemons(_ limit: Int = 20, _ offset: Int = 0) async throws -> [Pokemon] {
        var pokemons: [Pokemon] = []
        
        print("[info] Starting fetch pokemons...")
        
        let poemonsList = try await getPokemonsList(limit, offset)
        
        for i in 0 ..< limit {
            guard let url = URL(string: poemonsList.results[i].url) else {
                throw PokeapiErrors.invalidUrl
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw PokeapiErrors.invalidResponse
            }
            
            let decoder = JSONDecoder()
        
            let pokemon = try decoder.decode(Pokemon.self, from: data)
            
            pokemons.append(pokemon)
            
            print("[info] Fetched: \(pokemon.name) id: \(pokemon.id)")
        }
        print("[info] Stop fetching pokemons.")
        return pokemons
    }
    
    func getPokemonsList(_ limit: Int = 20, _ offset: Int = 0) async throws -> PokemonsList {
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: endpoint) else {
            throw PokeapiErrors.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
            
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PokeapiErrors.invalidResponse
        }
        
        var pokemonList: PokemonsList?
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        pokemonList = try decoder.decode(PokemonsList.self, from: data)
    
        guard let pokemonList = pokemonList else {
            throw PokeapiErrors.cantDecodePokemonsList
        }
        
        return pokemonList
    }
}
