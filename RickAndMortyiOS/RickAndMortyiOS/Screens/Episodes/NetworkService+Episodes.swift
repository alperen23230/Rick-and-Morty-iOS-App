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
        NetworkRoutes.sharedInstance.urlComponent.path = NetworkRoutes.Path.getEpisodes.rawValue
        
        NetworkRoutes.sharedInstance.urlComponent.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "name", value: filterByName)
        ]
       
        var urlRequest = URLRequest(url: NetworkRoutes.sharedInstance.urlComponent.url!)
        
        urlRequest.httpMethod = HTTPTypes.GET.rawValue
        let publisher: AnyPublisher<GeneralAPIResponse<Episode>, Error> = fetchWithURLRequest(urlRequest)
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
