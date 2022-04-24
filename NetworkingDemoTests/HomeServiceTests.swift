//
//  HomeServiceTests.swift
//  NetworkingDemoTests
//
//  Created by Yusuf Kamil Ak on 24.04.22.
//

import XCTest
@testable import NetworkingDemo

class HomeServiceTests: XCTestCase {

    var sut: HomeService!

    // MARK: - Staging Tests

    func testHomeService_whenUsingCombineStrategy_getAllPosts() {
        let expectation = XCTestExpectation(description: "getAllPostsResponseFetchedByCombine")
        sut = HomeService(environment: .staging)
        sut.getPosts(by: .combine) { postItems in
            // Assuming absence of postItems response is unacceptable.
            XCTAssertNotNil(postItems, "PostItems should not be nil.")
            XCTAssertFalse(postItems!.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0)
    }

    func testHomeService_whenUsingAsyncAwaitStrategy_getAllPosts() {
        let expectation = XCTestExpectation(description: "getAllPostsResponseFetchedByAsyncAwait")
        sut = HomeService(environment: .staging)
        sut.getPosts(by: .asyncAwait) { postItems in
            // Assuming absence of postItems response is unacceptable.
            XCTAssertNotNil(postItems, "PostItems should not be nil.")
            XCTAssertFalse(postItems!.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0)
    }

    func testHomeService_whenUsingCallbackStrategy_getAllPosts() {
        let expectation = XCTestExpectation(description: "getAllPostsResponseFetchedByCallback")
        sut = HomeService(environment: .staging)
        sut.getPosts(by: .callback) { postItems in
            // Assuming absence of postItems response is unacceptable.
            XCTAssertNotNil(postItems, "PostItems should not be nil.")
            XCTAssertFalse(postItems!.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0)
    }
}
