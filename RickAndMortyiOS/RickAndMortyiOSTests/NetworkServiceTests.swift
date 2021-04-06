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
    var expectationAPIResponse: XCTestExpectation!
    let timeoutForAPIResponse = 2.0

    override func setUpWithError() throws {
        expectationAPIResponse = expectation(description: "API respond on time")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_get_characters() {
        defer { waitForExpectations(timeout: timeoutForAPIResponse) }

        NetworkService.sharedInstance.getCharacters(for: 1, filterByName: "", filterByGender: "", filterByStatus: "").sink { (completion) in
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
}
