//
//  MockNetworkManager.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 20.08.2024.
//

import XCTest
@testable import ObiletCaseApp

final class MockNetworkManager: NetworkManaging {
    var requestCalled = false
    var requestCalledCount = 0
    var resultToReturn: Result<[Decodable], Error>?
    func request<T>(_ path: ObiletCaseApp.NetworkPath, decodeToType type: T.Type, method: ObiletCaseApp.NetworkType, completion: @escaping (Result<T, Error>) -> ()) where T : Decodable, T : Encodable {
        requestCalled = true
        requestCalledCount += 1
        if let result = resultToReturn as? Result<T,Error> {
            completion(result)
        }
    }
    
    
}
