//
//  PokemonDetailsViewController.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 29.10.2024.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    // MARK: - Variables

    var pokemon: Pokemon?

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let pokemonImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private let basicStatsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()

    private let extraStatsView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lyfecicle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - UI Setup

private extension PokemonDetailsViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground

        // MARK: - PokemonDetails error body

        guard let pokemon = pokemon else {
            basicStatsLabel.text = "Pokemon not found!"

            view.addSubview(basicStatsLabel)

            NSLayoutConstraint.activate([
                basicStatsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                basicStatsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
            return
        }

        // MARK: - PokemonDetails default body

        navigationItem.title = pokemon.name.capitalizingFirstWord()

        basicStatsLabel.text = "WEIGHT: \(pokemon.weight)kg HEIGHT: \(pokemon.height)m"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(pokemonImage)
        contentView.addSubview(basicStatsLabel)
        contentView.addSubview(extraStatsView)

        pokemonImage.loadImage(pokemon.sprites.other.officialArtwork.frontDefault)

        for i in 0 ..< pokemon.stats.count {
            let horizontalStackView = UIStackView()
            horizontalStackView.spacing = 5
            horizontalStackView.axis = .vertical
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

            let statLabel = UILabel()
            statLabel.text = "\(pokemon.stats[i].stat.name.capitalizingFirstWord()): \(pokemon.stats[i].baseStat)"
            statLabel.numberOfLines = 0
            statLabel.font = .systemFont(ofSize: 16, weight: .regular)
            statLabel.translatesAutoresizingMaskIntoConstraints = false

            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.progress = (Float(pokemon.stats[i].baseStat) / 100.0)
            progressView.translatesAutoresizingMaskIntoConstraints = false

            horizontalStackView.addArrangedSubview(statLabel)
            horizontalStackView.addArrangedSubview(progressView)

            NSLayoutConstraint.activate([
                statLabel.heightAnchor.constraint(equalToConstant: 20),
                progressView.heightAnchor.constraint(equalToConstant: 4),
            ])

            extraStatsView.addArrangedSubview(horizontalStackView)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.1),

            pokemonImage.heightAnchor.constraint(equalToConstant: 250),
            pokemonImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            pokemonImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            pokemonImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),

            basicStatsLabel.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor, constant: 5),
            basicStatsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            extraStatsView.topAnchor.constraint(equalTo: basicStatsLabel.bottomAnchor, constant: 18),
            extraStatsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            extraStatsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
    }
}
