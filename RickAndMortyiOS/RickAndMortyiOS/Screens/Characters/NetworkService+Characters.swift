//
//  NetworkService+Characters.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 5.12.2020.
//

import Foundation
import Combine

extension NetworkService {
    func getCharacters(for page: Int, filterByName: String, filterByGender: String, filterByStatus: String) -> Future<GeneralAPIResponse<Character>, APIError> {
        
        var urlRequest = URLRequest(url:Endpoint.getCharacters(name: filterByName, status: filterByStatus, gender: filterByGender, page: page).url)
        
        urlRequest.httpMethod = HTTPTypes.GET.rawValue
        let publisher: AnyPublisher<GeneralAPIResponse<Character>, Error> = fetchWithURLRequest(urlRequest)
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
