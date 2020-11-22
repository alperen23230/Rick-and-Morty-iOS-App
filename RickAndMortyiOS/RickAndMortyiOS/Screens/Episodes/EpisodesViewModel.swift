//
//  EpisodesViewModel.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 22.11.2020.
//

import Foundation
import Combine

class EpisodesViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var isLoadingPage = false
    
    let episodesSubject = CurrentValueSubject<[Episode], Never>([])
    var currentSearchQuery = ""
    var currentPage = 1
    var canLoadMorePages = true
    
    func getEpisodes() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        NetworkService.sharedInstance.getEpisodes(for: currentPage, filterByName: currentSearchQuery).sink {[weak self] (completion) in
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
            self?.episodesSubject.value.append(contentsOf: locationResponseModel.results)
        }
        .store(in: &cancellables)
    }
}
