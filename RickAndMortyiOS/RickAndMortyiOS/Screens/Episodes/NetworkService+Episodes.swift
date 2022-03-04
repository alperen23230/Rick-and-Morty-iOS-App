//
//  NetworkService+Episodes.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 22.11.2020.
//

import Foundation
import Combine

extension NetworkService {
    func getEpisodes(for page: Int, filterByName: String) -> Future<GeneralAPIResponse<Episode>, APIError> {
        let request = EpisodesRequest(name: filterByName, page: page)
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
