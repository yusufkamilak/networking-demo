//
//  HomeServiceMockTests.swift
//  NetworkingDemoTests
//
//  Created by Yusuf Kamil Ak on 24.04.22.
//

import XCTest
@testable import NetworkingDemo

class HomeServiceMockTests: XCTestCase {

    var sut: HomeServiceMock!

    // MARK: - Mock Tests

    func testHomeServiceMock_whenUsingCombineStrategy_getAllPosts() {
        let expectation = XCTestExpectation(description: "getAllPostsResponseFetchedByCombine")
        sut = HomeServiceMock()
        sut.getPosts(by: .combine) { postItems in
            // Assuming absence of postItems response is unacceptable.
            XCTAssertNotNil(postItems, "PostItems should not be nil.")
            XCTAssertFalse(postItems!.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0)
    }

    func testHomeServiceMock_whenUsingAsyncAwaitStrategy_getAllPosts() {
        let expectation = XCTestExpectation(description: "getAllPostsResponseFetchedByAsyncAwait")
        sut = HomeServiceMock()
        sut.getPosts(by: .asyncAwait) { postItems in
            // Assuming absence of postItems response is unacceptable.
            XCTAssertNotNil(postItems, "PostItems should not be nil.")
            XCTAssertFalse(postItems!.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0)
    }

    func testHomeServiceMock_whenUsingCallbackStrategy_getAllPosts() {
        let expectation = XCTestExpectation(description: "getAllPostsResponseFetchedByCallback")
        sut = HomeServiceMock()
        sut.getPosts(by: .callback) { postItems in
            // Assuming absence of postItems response is unacceptable.
            XCTAssertNotNil(postItems, "PostItems should not be nil.")
            XCTAssertFalse(postItems!.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0)
    }
}
