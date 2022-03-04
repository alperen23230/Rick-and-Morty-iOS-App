//
//  NetworkService+Characters.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 5.12.2020.
//

import Foundation
import Combine

extension NetworkService {
    func getCharacters(for page: Int, filterByName: String, filterByGender: String, filterByStatus: String) -> Future<GeneralAPIResponse<RickAndMortyCharacter>, APIError> {
        let request = CharactersRequest(name: filterByName, status: filterByStatus, gender: filterByGender, page: page)
        let publisher = fetchWithURLRequest(request)
        return Future { promise in
            publisher.sink { (completion) in
                if case .failure(let error) = completion, let apiError = error as? APIError {
                    promise(.failure(apiError))
                }
            } receiveValue: { (responseModel) in
                promise(.success(responseModel))
            }
            .store(in: &self.cancellables)
        }
    }
}
