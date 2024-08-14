//
//  AFNetworkManager.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation
import Alamofire

//MARK: - Protocol
protocol NetworkManaging {
    
    func request<T: Codable>(_ path: NetworkPath,
                             decodeToType type: T.Type,
                             method : NetworkType,
                             completion: @escaping (Result<T,Error>) -> ())
}

//MARK: - Class

class AFNetworkManager : NetworkManaging   {
    
    /// Fetch all request
    /// - Parameters:
    ///   - url: Network Path
    ///   - type: Decode Type
    ///   - method: Network Type
    ///   - completion: if everything is okey completion .success runs otherwise .failure runs
    func request<T: Codable>(_ path: NetworkPath,
                             decodeToType type: T.Type,
                             method : NetworkType,
                             completion: @escaping (Result<T,Error>) -> ()) {
        AF.request(path.urlString, method: method.toAlamofire()).responseData { response in
            
            switch response.result {
                
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(type.self, from: data)
                    
                    completion(.success(result))
                } catch {
                    
                    completion(.failure(error))
                }
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
    
    
}


