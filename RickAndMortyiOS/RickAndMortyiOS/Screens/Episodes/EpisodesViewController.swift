//
//  EpisodesViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import UIKit
import Combine
import Resolver

class EpisodesViewController: UIViewController {
    //UI Variables
    @UsesAutoLayout
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let searchController = UISearchController()
    //Variables
    private var dataSource: UITableViewDiffableDataSource<Section, Episode>!
    private var cancellables = Set<AnyCancellable>()
    @LazyInjected private var episodesViewModel: EpisodesViewModel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureDataSource()
        setViewModelListeners()
        configureSearchController()
        setSearchControllerListeners()
        episodesViewModel.getEpisodes()
    }
    
    private func configureNavBar() {
        navigationItem.searchController = searchController
        title = "Episodes"
    }
    
    private func setViewModelListeners() {
        Publishers.CombineLatest(episodesViewModel.isFirstLoadingPageSubject, episodesViewModel.episodesSubject).sink {[weak self] (isLoading, episodes) in
            if isLoading {
                self?.tableView.setLoading()
            } else {
                self?.tableView.restore()
                self?.createSnapshot(from: episodes)
                if episodes.isEmpty {
                    self?.tableView.setEmptyMessage(message: "No episode found")
                } else {
                    self?.tableView.restore()
                }
            }
        }
        .store(in: &cancellables)
    }
    
}

// MARK: - Table View Data Source Configurations
extension EpisodesViewController: UITableViewDelegate {
    fileprivate enum Section {
        case main
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
    }
    
    private func configureDataSource(){
        dataSource = UITableViewDiffableDataSource<Section, Episode>(tableView: tableView) {(tableView, indexPath, episodeModel) -> UITableViewCell? in
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = "\(episodeModel.episodeCode) - \(episodeModel.name)"
            cell.textLabel?.textColor = .rickBlue
            return cell
        }
    }
    
    private func createSnapshot(from addedEpisodes: [Episode]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
        snapshot.appendSections([.main])
        snapshot.appendItems(addedEpisodes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let tableViewContentSizeHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (tableViewContentSizeHeight - 100 - scrollViewHeight) {
            episodesViewModel.getEpisodes()
        }
    }
}
// MARK: - Search Bar methods
extension EpisodesViewController: UISearchBarDelegate {
    private func configureSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search a Episode"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setSearchControllerListeners(){
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .map {
                ($0.object as! UISearchTextField).text
            }
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink {[weak self] (searchQuery) in
                self?.getEpisodesBySearchQuery(searchQuery: searchQuery ?? "")
            }
            .store(in: &cancellables)
    }
    
    private func getEpisodesBySearchQuery(searchQuery: String) {
        episodesViewModel.currentSearchQuery = searchQuery
        episodesViewModel.canLoadMorePages = true
        episodesViewModel.currentPage = 1
        episodesViewModel.episodesSubject.value.removeAll()
        episodesViewModel.getEpisodes()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if episodesViewModel.currentSearchQuery != "" {
            getEpisodesBySearchQuery(searchQuery: "")
        }
    }
}
