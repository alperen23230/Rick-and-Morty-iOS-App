//
//  CharactersViewModel.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 6.12.2020.
//

import Foundation
import Combine

class CharactersViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private var isLoadingPage = false
    
    let charactersSubject = CurrentValueSubject<[Character], Never>([])
    var currentSearchQuery = ""
    var currentPage = 1
    var canLoadMorePages = true
    
    func getCharacters() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        NetworkService.sharedInstance.getCharacters(for: currentPage, filterByName: currentSearchQuery, filterByGender: "", filterByStatus: "").sink {[weak self] (completion) in
            if case .failure(let apiError) = completion {
                self?.isLoadingPage = false
                print(apiError.errorMessage)
            }
        } receiveValue: {[weak self] (characterResponseModel) in
            self?.isLoadingPage = false
            if characterResponseModel.pageInfo.pageCount == self?.currentPage {
                self?.canLoadMorePages = false
            }
            self?.currentPage += 1
            self?.charactersSubject.value.append(contentsOf: characterResponseModel.results)
        }
        .store(in: &cancellables)
    }
    
}
