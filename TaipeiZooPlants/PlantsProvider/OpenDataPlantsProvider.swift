//
//  OpenDataPlantsProvider.swift
//  TaipeiZooPlants
//
//  Created by Arthur Kao on 2022/1/8.
//

import Foundation
import Alamofire

class OpenDataPlantsProvider: PlantsProviderType {
    
    init() {}
    private let apiURL = "https://data.taipei/opendata/datalist/apiAccess"
    
    private let query: [String: String] = [
        "scope": "resourceAquire",
        "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14"
    ]
    
    func fetchPlants(limit: Int, offset: Int) async throws -> [Plant] {
        let data: Data = try await withUnsafeThrowingContinuation { continuation in
            var urlComponents = URLComponents(string: apiURL)!
            var query = query
            query["limit"] = "\(limit)"
            query["offset"] = "\(offset)"
            urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
            do {
                let request = try URLRequest(
                    url: urlComponents.asURL(),
                    method: .get,
                    headers: nil
                )
                AF.request(request).responseData { response in
                    continuation.resume(with: response.result)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
        return try JSONDecoder().decode(OpenDataResponse<[Plant]>.self, from: data).results
    }
}

extension OpenDataPlantsProvider {
    
    struct Plant: Decodable {
        
        let name: String
        let location: String
        let feature: String
        let pic: String
        
        enum CodingKeys: String, CodingKey {
            case name =  "F_Name_Ch"
            case location =  "F_Location"
            case feature = "F_Feature"
            case pic = "F_Pic01_URL"
        }
    }
    
    struct OpenDataResponse<T: Decodable>: Decodable {
        
        let limit: Int
        let offset: Int
        let sort: String
        let results: T
        
        private enum UnwrapKey: String, CodingKey {
            case result
            case limit
            case offset
            case sort
            case results
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: UnwrapKey.self)
            let resultContainer = try container.nestedContainer(keyedBy: UnwrapKey.self, forKey: .result)
            limit = try resultContainer.decode(Int.self, forKey: .limit)
            offset = try resultContainer.decode(Int.self, forKey: .offset)
            sort = try resultContainer.decode(String.self, forKey: .sort)
            results = try resultContainer.decode(T.self, forKey: .results)
        }
    }
}
