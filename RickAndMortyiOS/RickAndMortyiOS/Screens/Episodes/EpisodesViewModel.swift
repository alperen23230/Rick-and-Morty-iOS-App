//
//  EpisodesViewModel.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 22.11.2020.
//

import Foundation
import Combine
import Resolver

class EpisodesViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var isLoadingPage = false
    
    let isFirstLoadingPageSubject = CurrentValueSubject<Bool, Never>(true)
    
    let episodesSubject = CurrentValueSubject<[Episode], Never>([])
    var currentSearchQuery = ""
    var currentPage = 1
    var canLoadMorePages = true

    @LazyInjected private var networkService: NetworkService
    
    func getEpisodes() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        networkService.getEpisodes(for: currentPage, filterByName: currentSearchQuery).sink {[weak self] (completion) in
            if case .failure(let apiError) = completion {
                self?.isLoadingPage = false
                print(apiError.errorMessage)
            }
        } receiveValue: {[weak self] (episodeResponseModel) in
            self?.isLoadingPage = false
            if episodeResponseModel.pageInfo.pageCount == self?.currentPage {
                self?.canLoadMorePages = false
            }
            self?.currentPage += 1
            self?.episodesSubject.value.append(contentsOf: episodeResponseModel.results)
            self?.isFirstLoadingPageSubject.value = false
        }
        .store(in: &cancellables)
    }
}
