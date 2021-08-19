//
//  APICaller.swift
//  OpenTweet
//
//  Created by Lawson Kelly on 8/17/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

final class APICaller {
    static let shared = APICaller()

    private init() {}

    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }

    public func getTimeLine
    (fileName: String,
     completion: @escaping ((Result<Timeline, Error>) -> Void)
    ) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return
        }
        let fileUrl = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: fileUrl) else {
            return
        }
        do {
            let result = try JSONDecoder().decode(Timeline.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
