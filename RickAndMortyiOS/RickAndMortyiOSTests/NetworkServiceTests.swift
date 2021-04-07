//
//  NetworkServiceTests.swift
//  RickAndMortyiOSTests
//
//  Created by Alperen Ünal on 6.04.2021.
//

import XCTest
import Combine
@testable import RickAndMortyiOS

class NetworkServiceTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private var expectationAPIResponse: XCTestExpectation!
    // System Under Test
    private var sut: NetworkService!
    private let timeoutForAPIResponse = 5.0


    override func setUp() {
        expectationAPIResponse = expectation(description: "API respond on time")
        sut = NetworkService()
    }

    override func tearDown() {
        expectationAPIResponse = nil
        sut = nil
    }

    func test_get_characters() {
        defer { waitForExpectations(timeout: timeoutForAPIResponse) }

        sut.getCharacters(for: 1, filterByName: "", filterByGender: "", filterByStatus: "").sink { (completion) in
            if case .failure(_) = completion {
                XCTFail("API return error on first page of characters")
            }
        } receiveValue: { [weak self] (response) in
            guard let self = self else { return XCTFail() }
            XCTAssertNotNil(response)
            do { self.expectationAPIResponse.fulfill() }
        }
            .store(in: &cancellables)
    }

    func test_get_episodes() {
        defer { waitForExpectations(timeout: timeoutForAPIResponse) }

        sut.getEpisodes(for: 1, filterByName: "").sink { (completion) in
            if case .failure(_) = completion {
                XCTFail("API return error on first page of episodes")
            }
        } receiveValue: { [weak self] (response) in
            guard let self = self else { return XCTFail() }
            XCTAssertNotNil(response)
            do { self.expectationAPIResponse.fulfill() }
        }
            .store(in: &cancellables)
    }

    func test_get_locations() {
        defer { waitForExpectations(timeout: timeoutForAPIResponse) }

        sut.getLocations(for: 1, filterByName: "").sink { (completion) in
            if case .failure(_) = completion {
                XCTFail("API return error on first page of locations")
            }
        } receiveValue: { [weak self] (response) in
            guard let self = self else { return XCTFail() }
            XCTAssertNotNil(response)
            do { self.expectationAPIResponse.fulfill() }
        }
            .store(in: &cancellables)
    }
}
