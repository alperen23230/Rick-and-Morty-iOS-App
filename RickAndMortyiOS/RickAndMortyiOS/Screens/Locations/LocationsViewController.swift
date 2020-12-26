//
//  LocationsViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import UIKit
import Combine
import Resolver

class LocationsViewController: UIViewController {
    
    @UsesAutoLayout
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let searchController = UISearchController()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Location>!
    private var cancellables = Set<AnyCancellable>()
    @LazyInjected private var locationsViewModel: LocationsViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureDataSource()
        setViewModelListeners()
        configureSearchController()
        setSearchControllerListeners()
        locationsViewModel.getLocations()
    }
    
    private func configureNavBar() {
        navigationItem.searchController = searchController
        title = "Locations"
    }
    
    private func setViewModelListeners() {
        Publishers.CombineLatest(locationsViewModel.isFirstLoadingPageSubject, locationsViewModel.locationsSubject).sink {[weak self] (isLoading, locations) in
            if isLoading {
                self?.tableView.setLoading()
            } else {
                self?.tableView.restore()
                self?.createSnapshot(from: locations)
                if locations.isEmpty {
                    self?.tableView.setEmptyMessage(message: "No location found")
                } else {
                    self?.tableView.restore()
                }
            }
        }
        .store(in: &cancellables)
    }
}

//Table View Data Source Configurations
extension LocationsViewController: UITableViewDelegate {
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
        dataSource = UITableViewDiffableDataSource<Section, Location>(tableView: tableView) {(tableView, indexPath, locationModel) -> UITableViewCell? in
            let cell = UITableViewCell()
            cell.textLabel?.text = locationModel.name
            cell.textLabel?.textColor = .rickBlue
            return cell
        }
    }
    
    private func createSnapshot(from addedLocations: [Location]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Location>()
        snapshot.appendSections([.main])
        snapshot.appendItems(addedLocations)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let tableViewContentSizeHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (tableViewContentSizeHeight - 100 - scrollViewHeight) {
            locationsViewModel.getLocations()
        }
    }
}

extension LocationsViewController: UISearchBarDelegate {
    private func configureSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search a Location"
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
                self?.getLocationsBySearchQuery(searchQuery: searchQuery ?? "")
            }
            .store(in: &cancellables)
    }
    
    private func getLocationsBySearchQuery(searchQuery: String) {
        locationsViewModel.currentSearchQuery = searchQuery
        locationsViewModel.canLoadMorePages = true
        locationsViewModel.currentPage = 1
        locationsViewModel.locationsSubject.value.removeAll()
        locationsViewModel.getLocations()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if locationsViewModel.currentSearchQuery != "" {
            getLocationsBySearchQuery(searchQuery: "")
        }
    }
}
