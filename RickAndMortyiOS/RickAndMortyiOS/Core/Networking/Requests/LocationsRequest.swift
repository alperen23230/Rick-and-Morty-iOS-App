//
//  LocationsRequest.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 4.03.2022.
//

final class LocationsRequest: NetworkRequestProtocol {
    typealias ResponseType = GeneralAPIResponse<Location>

    let endpoint: Endpoint
    let method: HTTPMethod = .GET

    init(name: String, page: Int) {
        endpoint = .getLocations(for: name, page: page)
    }
}
