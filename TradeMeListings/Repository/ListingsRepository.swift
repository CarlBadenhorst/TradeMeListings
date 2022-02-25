//
//  ListingsRepository.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/24.
//

import Foundation
import Combine

protocol IListingsRepository {
    func fetchListings() -> AnyPublisher<ListingDto, Error>
}

struct ListingsRepository: IListingsRepository {
    func fetchListings() -> AnyPublisher<ListingDto, Error> {
        let urlString = "https://api.tmsandbox.co.nz/v1/listings/latest.json?rows=20"
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: "", code: -1001, userInfo: nil)).eraseToAnyPublisher()
        }
        var request = createRequest(url)
        return serviceCall(request)
    }
}

extension ListingsRepository {
    func createRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        var newHeaders = [String: String]()
        newHeaders["Authorization"] = "OAuth oauth_consumer_key=\"A1AC63F0332A131A78FAC304D007E7D1\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"1645783459\",oauth_nonce=\"mkoCri\",oauth_version=\"1.0\",oauth_signature=\"I5V9aAAdLctr4BKwav5Fo6JicVk%3D\""
        newHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        newHeaders["oauth_signature_method"] = "PLAINTEXT"
        newHeaders["oauth_signature"] = "EC7F18B17A062962C6930A8AE88B16C7"
        newHeaders["oauth_consumer_key"] = "A1AC63F0332A131A78FAC304D007E7D1"
        request.allHTTPHeaderFields = newHeaders
        return request
    }
    
    func serviceCall<Value: Decodable>(_ request: URLRequest) -> AnyPublisher<Value, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap {
                    guard let response = $0.1 as? HTTPURLResponse, response.statusCode == 200 else {
                        print($0)
                        throw HTTPError.statusCode
                    }
                    return $0.data
                }
                .decode(type: Value.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
}

enum HTTPError: LocalizedError {
    case statusCode
}

