//
//  PokemonsListViewController.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 27.10.2024.
//

import UIKit

class PokemonListViewController: UIViewController {
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

    private let repository = PokemonRepository()

    private lazy var model = PokemonListModel(repository: repository)

    private lazy var viewModel = PokemonListViewModel(model: model)

    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
}

private extension PokemonListViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Pokemons"

        navigationController?.navigationBar.prefersLargeTitles = true

        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true

        view.addSubview(activityIndicator)
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    func loadData() {
        // Start animating indicator before fetching data
        activityIndicator.startAnimating()

        Task {
            await viewModel.fetchPockemons()

            // Stop and remove indicator, then reload table view
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.tableView.reloadData()
            }
        }
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.cellID, for: indexPath) as? PokemonTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModel.pokemons[indexPath.row])
        return cell
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle the tap here
        print("Cell tapped at row \(indexPath.row)")
        // Optionally, deselect the row with animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
