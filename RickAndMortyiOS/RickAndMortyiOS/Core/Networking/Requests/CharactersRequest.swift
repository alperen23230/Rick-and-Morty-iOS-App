//
//  CharactersRequest.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 4.03.2022.
//

final class CharactersRequest: NetworkRequestProtocol {
    typealias ResponseType = GeneralAPIResponse<RickAndMortyCharacter>

    let endpoint: Endpoint
    let method: HTTPMethod = .GET

    init(name: String, status: String, gender: String, page: Int) {
        endpoint = .getCharacters(name: name, status: status,
                                  gender: gender, page: page)
    }
}
