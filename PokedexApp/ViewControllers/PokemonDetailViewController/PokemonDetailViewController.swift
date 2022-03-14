//
//  PokemonDetailViewController.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit

class PokemonDetailViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
        tableView.register(PokemonAbilitiesTableViewCell.self, forCellReuseIdentifier: "PokemonAbilitiesTableViewCell")
        tableView.register(PokemonCharacteristicsTableViewCell.self, forCellReuseIdentifier: "PokemonCharacteristicsTableViewCell")
        tableView.register(PokemonStatsTableViewCell.self, forCellReuseIdentifier: "PokemonStatsTableViewCell")
        tableView.register(PokemonHeaderTableViewCell.self, forCellReuseIdentifier: "PokemonHeaderTableViewCell")
        tableView.register(WideScreenLoaderTableViewCell.self, forCellReuseIdentifier: "WideScreenLoaderTableViewCell")
        tableView.register(AbilityTableViewCell.self, forCellReuseIdentifier: "AbilityTableViewCell")

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureConstraints()
        self.configureNavigationBar()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        
    }
        
    private var tableViewDataSource: [PokemonDetailViewController.TableViewDataSource] = []
    private var viewModel: PokemonDetailViewModel?
    private var abilityViewModel: AbilityViewModel?
    
    init(viewModel: PokemonDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel?.retrieve(pokemon: viewModel.pokemonName)
        self.viewModel?.retrievedPokemon = { hasSucceeded in
            DispatchQueue.main.async {
                self.abilityViewModel = AbilityViewModel(abilities: self.viewModel?.pokemon?.abilities ?? [])
                self.instantiateDataSource()
            }
        }
        self.instantiateDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func instantiateDataSource(with abilities: [Ability] = []) {
        self.tableViewDataSource = []
        
        guard let pokemon = self.viewModel?.pokemon else {
            self.tableViewDataSource.append(.header(image: nil))
            return
        }
        
        self.tableViewDataSource.append(.header(image: pokemon.highQualityImage ?? UIImage()))
        self.tableViewDataSource.append(.physicalCharacteristics(types: pokemon.type,
                                                                 weight: pokemon.weight ?? 0,
                                                                 height: pokemon.height ?? 0,
                                                                 baseExperience: pokemon.baseExperience ?? 0,
                                                                 isBaby: pokemon.isBaby ?? false))
        self.tableViewDataSource.append(.stats(stats: pokemon.stats,
                                               happiness: pokemon.happiness ?? 0,
                                               captureRate: pokemon.captureRate ?? 0))
        self.tableViewDataSource.append(.abilities(viewModel: self.abilityViewModel))
        
        if !abilities.isEmpty {
            abilities.forEach() { ability in
                self.tableViewDataSource.append(.abilityItem(ability: ability))
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = self.viewModel?.pokemonName.capitalized.replacingOccurrences(of: "-", with: " ")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        if #available(iOS 13.0, *) {
            navigationItem.setupRightAppearance()
        }
                
        let backItem = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationController?.navigationBar.backItem?.setLeftBarButton(backItem, animated: true)

    }
    
    private func configureConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: 0),
            self.view.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
}

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewDataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = self.tableViewDataSource[indexPath.row]
        
        switch cellType {
        case .loader:
            return 500
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.tableViewDataSource[indexPath.row]
        
        switch cellType {
        case .header(let image):
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "PokemonHeaderTableViewCell", for: indexPath) as? PokemonHeaderTableViewCell {
                cell.configure(with: image)
                return cell
            }
        case .physicalCharacteristics(let types, let weight, let height, let baseExperience, let isBaby):
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "PokemonCharacteristicsTableViewCell", for: indexPath) as? PokemonCharacteristicsTableViewCell {
                cell.configure(with: types, weight: weight, height: height, baseExperience: baseExperience, isBaby: isBaby)
                return cell
            }
        case .stats(let stats, let happiness, let captureRate):
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "PokemonStatsTableViewCell", for: indexPath) as? PokemonStatsTableViewCell {
                cell.configure(with: stats, happiness: happiness, captureRate: captureRate)
                return cell
            }
            
        case .loader:
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "WideScreenLoaderTableViewCell", for: indexPath) as? WideScreenLoaderTableViewCell {
                return cell
            }
        case .abilities(let viewModel):
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "PokemonAbilitiesTableViewCell", for: indexPath) as? PokemonAbilitiesTableViewCell {
                cell.configure(viewModel: viewModel, delegate: self)
                return cell
            }
            break
            
        case .abilityItem(let ability):
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "AbilityTableViewCell", for: indexPath) as? AbilityTableViewCell {
                cell.configure(title: ability.name, description: ability.description)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension PokemonDetailViewController: PokemonAbilitiesDelegate {
    func retrieved(abilities: [Ability]) {
        self.instantiateDataSource(with: abilities)
    }
}

extension PokemonDetailViewController {
    enum TableViewDataSource {
        case header(image: UIImage?)
        case loader
        case stats(stats: [Stat], happiness: Int, captureRate: Int)
        case abilities(viewModel: AbilityViewModel?)
        case abilityItem(ability: Ability)
        case physicalCharacteristics(types: [String], weight: Int, height: Int, baseExperience: Int, isBaby: Bool)
    }
}
