//
//  LocationsViewModel.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 21.11.2020.
//

import Foundation
import Combine

class LocationsViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private var isLoadingPage = false
    
    let locationsSubject = CurrentValueSubject<[Location], Never>([])
    let isFirstLoadingPageSubject = CurrentValueSubject<Bool, Never>(true)
    var currentSearchQuery = ""
    var currentPage = 1
    var canLoadMorePages = true
    
    func getLocations() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        NetworkService.sharedInstance.getLocations(for: currentPage, filterByName: currentSearchQuery).sink {[weak self] (completion) in
            if case .failure(let apiError) = completion {
                self?.isLoadingPage = false
                print(apiError.errorMessage)
            }
        } receiveValue: {[weak self] (locationResponseModel) in
            self?.isLoadingPage = false
            if locationResponseModel.pageInfo.pageCount == self?.currentPage {
                self?.canLoadMorePages = false
            }
            self?.currentPage += 1
            self?.locationsSubject.value.append(contentsOf: locationResponseModel.results)
            self?.isFirstLoadingPageSubject.value = false
        }
        .store(in: &cancellables)
    }
}
