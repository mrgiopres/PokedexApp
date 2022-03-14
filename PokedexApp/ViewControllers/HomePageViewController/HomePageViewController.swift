//
//  HomePageViewController.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 06/03/22.
//

import Foundation
import UIKit
import PokemonAPI

class HomePageViewController: UIViewController {
    private var splashScreen: SplashScreenView = SplashScreenView()
    
    private var lblCollectionView: UILabel = {
        var lblCollectionView = UILabel()
        lblCollectionView.numberOfLines = 1
        lblCollectionView.textAlignment = .left
        lblCollectionView.text = "Recommendations"
        lblCollectionView.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lblCollectionView
    }()
    
    private let tableViewFooter: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .white
        footerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return footerView
    }()

    private var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)), collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PokemonCardViewCell.self, forCellWithReuseIdentifier: "PokemonCardViewCell")
        return collectionView
    }()
    
    private var lblPokemonlist: UILabel = {
        var lblPokemonlist = UILabel()
        lblPokemonlist.numberOfLines = 1
        lblPokemonlist.textAlignment = .left
        lblPokemonlist.text = "All Pokémons"
        lblPokemonlist.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lblPokemonlist
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isUserInteractionEnabled = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1).withAlphaComponent(0.5)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: "LoadingTableViewCell")
        tableView.register(ListedPokemonTableViewCell.self, forCellReuseIdentifier: "ListedPokemonTableViewCell")
        return tableView
    }()
    
    private var lblMain: UILabel = {
        let lblMain = UILabel()
        lblMain.attributedText = PokedexApp.shared.mainAttributedString
        lblMain.numberOfLines = 1
        return lblMain
    }()
    
    private var searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.setImage(UIImage(named: "cta_search"), for: .normal)
        searchButton.isUserInteractionEnabled = true
        return searchButton
    }()
    
    private var containerView: UIView = {
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        return containerView
    }()
    
    private var tableViewDataSource: [HomePageViewController.TableViewDataSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.preconfigureTableView()
        self.preconfigureCollectionView()
        self.configureLayout()
        self.splashScreen.configure(on: self.view)
        self.title = "Home"
        self.navigationItem.largeTitleDisplayMode = .always
        self.view.backgroundColor = #colorLiteral(red: 0.9138582349, green: 0.712510407, blue: 0.6921096444, alpha: 1)
        self.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    private var viewModel: HomePageViewModel?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: HomePageViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        
        self.viewModel?.retrievedFirstPage = { hasSucceeded in
            DispatchQueue.main.async {
                if hasSucceeded {
                    self.splashScreen.dismiss()
                    self.instantiateTableViewDataSource()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                } else {
                    /// Do things if call has failed
                }
            }
        }
        
        self.viewModel?.retrievedPage = { hasSucceeded in
            if hasSucceeded {
                DispatchQueue.main.async {
                    self.instantiateTableViewDataSource()
                    self.tableView.reloadData()
                    self.tableView.scrollToNearestSelectedRow(at: .bottom, animated: false)
                }
            }
        }
        DispatchQueue.main.async {
            self.viewModel?.retrievePokemonList()
        }
    }
    
    private func preconfigureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func preconfigureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func instantiateTableViewDataSource() {
        self.tableViewDataSource = []
        self.viewModel?.pokemonPages.forEach() { page in
            page.pokemons.forEach() { pokemon in
                self.tableViewDataSource.append(.pokemon(name: pokemon.getPrettyName(), identifier: pokemon.name))
            }
        }
        self.tableViewDataSource.append(.loading)
    }
    
    @objc func searchButtonPressed() {
        self.viewModel?.startSearchFlow(from: self)
    }
    
    private func configureLayout() {
        self.lblMain.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.lblCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.lblPokemonlist.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(lblMain)
        self.view.addSubview(searchButton)
        self.view.addSubview(containerView)
        self.containerView.addSubview(lblCollectionView)
        self.containerView.addSubview(collectionView)
        self.containerView.addSubview(lblPokemonlist)
        self.containerView.addSubview(tableView)
        
        let lblMainConstraints: [NSLayoutConstraint] = [
            self.lblMain.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.searchButton.trailingAnchor.constraint(greaterThanOrEqualTo: self.lblMain.leadingAnchor, constant: 20),
            self.lblMain.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        
        let searchButtonConstraints: [NSLayoutConstraint] = [
            self.searchButton.widthAnchor.constraint(equalToConstant: 20),
            self.searchButton.heightAnchor.constraint(equalToConstant: 20),
            self.searchButton.centerYAnchor.constraint(equalTo: self.lblMain.centerYAnchor, constant: 5),
            self.view.trailingAnchor.constraint(equalTo: self.searchButton.trailingAnchor, constant: 20)
        ]
        
        let containerViewConstraints: [NSLayoutConstraint] = [
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
            self.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0),
            self.containerView.topAnchor.constraint(equalTo: self.lblMain.bottomAnchor, constant: 30)
        ]
        
        let lblCollectionViewConstraints: [NSLayoutConstraint] = [
            self.lblCollectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.containerView.trailingAnchor.constraint(equalTo: self.lblCollectionView.trailingAnchor, constant: 20),
            self.lblCollectionView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30),
            self.collectionView.topAnchor.constraint(equalTo: self.lblCollectionView.bottomAnchor, constant: 20)
        ]
        
        let collectionViewConstraints: [NSLayoutConstraint] = [
            self.collectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            self.containerView.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor, constant: 0),
            self.collectionView.heightAnchor.constraint(equalToConstant: PokemonCardViewCell.STD_DIMENSION)
        ]
        
        let lblPokemonListConstraints: [NSLayoutConstraint] = [
            self.lblPokemonlist.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.containerView.trailingAnchor.constraint(equalTo: self.lblPokemonlist.trailingAnchor, constant: 20),
            self.lblPokemonlist.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 30),
            self.tableView.topAnchor.constraint(equalTo: self.lblPokemonlist.bottomAnchor, constant: 20)
        ]
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            self.tableView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            self.containerView.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: 0),
            self.containerView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(searchButtonConstraints)
        NSLayoutConstraint.activate(lblMainConstraints)
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(collectionViewConstraints)
        NSLayoutConstraint.activate(lblCollectionViewConstraints)
        NSLayoutConstraint.activate(lblPokemonListConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
        
        self.view.layoutSubviews()
    }

}

extension HomePageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.relevantPokemons.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCardViewCell", for: indexPath) as? PokemonCardViewCell {
            cell.configure(with: self.viewModel?.relevantPokemons[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.openPokemonDetail(pokemonID: self.viewModel?.relevantPokemons[indexPath.row].name ?? "", from: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PokemonCardViewCell.STD_DIMENSION + 15, height: PokemonCardViewCell.STD_DIMENSION)
    }
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.tableViewDataSource[indexPath.row]
        
        switch cellType {
        case .pokemon(let name, let identifier):
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListedPokemonTableViewCell", for: indexPath) as? ListedPokemonTableViewCell {
                cell.configure(with: name, identifier: identifier)
                return cell
            }
        case .loading:
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as? LoadingTableViewCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.tableViewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = self.tableViewDataSource[indexPath.row]
        
        switch cellType {
        case .loading:
            return 60
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = self.tableViewDataSource[indexPath.row]
        
        switch cellType {
        case .pokemon(_ , let identifier):
            self.viewModel?.openPokemonDetail(pokemonID: identifier, from: self)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellType = self.tableViewDataSource[indexPath.row]
        
        switch cellType {
        case .loading:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.viewModel?.retrievePokemonPage(for: .next)
            }
        default:
            break
        }
    }
}

extension HomePageViewController {
    enum TableViewDataSource {
        case pokemon(name: String, identifier: String)
        case loading
    }
}
