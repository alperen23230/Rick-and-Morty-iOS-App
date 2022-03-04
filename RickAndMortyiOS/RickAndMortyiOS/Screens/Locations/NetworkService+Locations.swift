//
//  LocationsNetworkingRequests.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation
import Combine

extension NetworkService {
    func getLocations(for page: Int, filterByName: String) -> Future<GeneralAPIResponse<Location>, APIError> {
        let request = LocationsRequest(name: filterByName, page: page)
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
