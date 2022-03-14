//
//  SearchViewController.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1).withAlphaComponent(0.5)
        tableView.register(ListedPokemonTableViewCell.self, forCellReuseIdentifier: "ListedPokemonTableViewCell")

        return tableView
    }()
    
    private var searchView: SearchView = SearchView()
    private var viewModel: SearchViewModel?
        
    init(viewModel: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.searchView.delegate = self
        self.viewModel?.retrievedSearchItems = { hasSucceeded in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configureConstraints()
        self.configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .automatic
        if #available(iOS 13.0, *) {
            navigationItem.setupRightAppearance()
        }
                
        let backItem = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationController?.navigationBar.backItem?.setLeftBarButton(backItem, animated: true)
    }
    
    private func configureConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        self.view.addSubview(searchView)
        
        let searchViewConstraints: [NSLayoutConstraint] = [
            self.searchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: 0),
            self.tableView.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 0),
        ]
        
        let tableViewConstrains: [NSLayoutConstraint] = [
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: 0),
            self.view.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(searchViewConstraints)
        NSLayoutConstraint.activate(tableViewConstrains)
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.searchedItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListedPokemonTableViewCell", for: indexPath) as? ListedPokemonTableViewCell {
            cell.configure(with: self.viewModel?.searchedItems[indexPath.row].name.capitalized.replacingOccurrences(of: "-", with: " ") ?? "", identifier: self.viewModel?.searchedItems[indexPath.row].name ?? "")
            return cell
        }
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pokemonName = self.viewModel?.searchedItems[indexPath.row].name {
            self.viewModel?.openPokemonDetail(pokemonID: pokemonName, from: self)
        }
    }
}

extension SearchViewController: SearchDelegate {
    func startSearch(type: String?, name: String?) {
        self.viewModel?.search(pokemon: name?.lowercased().replacingOccurrences(of: " ", with: "-") ?? "")
    }
}

