//
//  PokemonsListViewController.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 27.10.2024.
//

import UIKit

class PokemonListViewController: UIViewController {
    // MARK: - Variables

    private let repository = PokemonRepository()

    private lazy var model = PokemonListModel(repository: repository)

    private lazy var viewModel = PokemonListViewModel(model: model)

    // MARK: - UI Components

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 44
        tv.separatorStyle = .singleLine
        tv.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.cellID)
        return tv
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lyfecicle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        setupSearchController()
        setupScopeBar()
    }
}

// MARK: - UI Setup

private extension PokemonListViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Pokemons"

        navigationController?.navigationBar.prefersLargeTitles = true

        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func loadData() {
        activityIndicator.startAnimating()

        Task {
            await viewModel.fetchPockemons()

            DispatchQueue.main.async {
                self.activityIndicator.removeFromSuperview()
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemons"

        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

// MARK: - UISearchResultsUpdating Setup

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.isSearchActive = !(searchController.searchBar.text?.isEmpty ?? true)

        if viewModel.isSearchActive {
            guard let searchText = searchController.searchBar.text?.lowercased() else { return }
            viewModel.searchPokemons(searchText)
            tableView.reloadData()
        }
    }
}

// MARK: - UITableView Setup

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearchActive || viewModel.isFilterActive {
            return viewModel.filteredPokemonsList.count
        } else {
            return viewModel.defaultPokemonsList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.cellID, for: indexPath) as? PokemonTableViewCell else {
            fatalError()
        }

        if viewModel.isSearchActive || viewModel.isFilterActive {
            cell.configure(with: viewModel.filteredPokemonsList[indexPath.row])
        } else {
            cell.configure(with: viewModel.defaultPokemonsList[indexPath.row])
        }

        return cell
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("[info] Cell tapped at row \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)

        var selectedPokemon: Pokemon

        if viewModel.isSearchActive || viewModel.isFilterActive {
            selectedPokemon = viewModel.filteredPokemonsList[indexPath.row]
        } else {
            selectedPokemon = viewModel.defaultPokemonsList[indexPath.row]
        }

        let detailsVC = PokemonDetailsViewController()
        detailsVC.pokemon = selectedPokemon

        navigationController?.pushViewController(detailsVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if !viewModel.pokemonsData.isEmpty && !viewModel.isLoadingData && position > contentHeight - frameHeight {
            print("[debug] Pagination starting...")

            Task {
                await viewModel.loadMoreData()

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension PokemonListViewController: UISearchBarDelegate {
    private func setupScopeBar() {
        searchController.searchBar.delegate = self

        if #available(iOS 16.0, *) {
            searchController.scopeBarActivation = .onSearchActivation
        } else {
            searchController.automaticallyShowsScopeBar = true
        }
        searchController.searchBar.scopeButtonTitles = [PokemonFilter.id.rawValue, PokemonFilter.name.rawValue]
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let filter = PokemonFilter.byID(selectedScope)
        viewModel.filterPokemons(by: filter)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isFilterActive = false
        viewModel.isSearchActive = false
        searchController.searchBar.selectedScopeButtonIndex = 0
        tableView.reloadData()
    }
}
