//
//  LocationsViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import UIKit
import Combine

class LocationsViewController: UIViewController {
    
    @UsesAutoLayout
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let searchController = UISearchController()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Location>!
    private var cancellables = Set<AnyCancellable>()
    
    private var locationsViewModel: LocationsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureDataSource()
        configureViewModel()
        configureSearchController()
        setSearchControllerListeners()
        locationsViewModel.getLocations()
    }
    
    private func configureSearchController(){
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
                self?.locationsViewModel.currentSearchQuery = searchQuery ?? ""
                self?.locationsViewModel.canLoadMorePages = true
                self?.locationsViewModel.currentPage = 1
                self?.locationsViewModel.locationsSubject.value.removeAll()
                self?.locationsViewModel.getLocations()
            }
            .store(in: &cancellables)
    }
    
    private func configureNavBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Locations"
    }
    
    private func configureViewModel() {
        locationsViewModel = LocationsViewModel()
        locationsViewModel.locationsSubject.sink {[weak self] (locations) in
            self?.createSnapshot(from: locations)
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
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
    }
    
    private func configureDataSource(){
        dataSource = UITableViewDiffableDataSource<Section, Location>(tableView: tableView) {(tableView, indexPath, locationModel) -> UITableViewCell? in
            let cell = UITableViewCell()
            cell.textLabel?.text = locationModel.name
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
