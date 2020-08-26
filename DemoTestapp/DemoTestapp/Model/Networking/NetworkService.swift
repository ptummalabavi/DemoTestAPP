//
//  NetworkService.swift
//  DemoTestapp
//
//  Created by Prashanth reddy on 8/26/20.
//  Copyright © 2020 Prashanth reddy. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchFeedsListAPI(request: URLRequest, completion: @escaping (Result<[FeedResult], NetworkError>) -> Void)
}


struct NetworkService: NetworkServiceProtocol {
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
}

extension NetworkService {
    
    func fetchFeedsListAPI(request: URLRequest, completion: @escaping (Result<[FeedResult], NetworkError>) -> Void) {
        self.session.dataTask(with: request) { (rawData, response, error) in
            if let aError = error {
                print(aError)
                completion(.failure(.fetch))
            } else {
                if let validData = rawData {
                    //Parse
                    do {
                        let result = try JSONDecoder().decode(FeedData.self, from: validData)
                        completion(.success(result.feed.results))
                    } catch( _) {
                        completion(.failure(.parse))
                    }
                }
            }
        }.resume()
        
    }
}
