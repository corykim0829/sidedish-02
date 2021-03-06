//
//  NetworkManager.swift
//  SideDishApp
//
//  Created by Cory Kim on 2020/04/24.
//  Copyright © 2020 corykim0829. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkErrorCase : Error {
    case InvalidURL
    case NotFound
}

class NetworkManager {
    
    enum EndPoints {
        static let Categories = "http://13.125.185.168:8080/categories"
        static let SideDishes = "http://13.125.185.168:8080/categories"
        static let Detail = "http://13.125.185.168:8080/banchan"
    }
    
    func getResource<T: Decodable>(from: String, path: String = "", type: T.Type, completion: @escaping (T?, Error?) -> ()) {
        let pathURL = (path != "") ? "/\(path)" : ""
        let requestURL = from + pathURL
        AF.request(requestURL).responseDecodable(of: T.self, queue: .global(qos: .background), decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let decodedData):
                completion(decodedData, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchImage(from: String, cachedImageFileURL: URL? = nil, completion: @escaping (Result<Data, NetworkErrorCase>) -> Void) {
        
        let URLRequest = URL(string: from)!
        
        URLSession.shared.downloadTask(with: URLRequest) { (url, _, error) in
            if error != nil { completion(.failure(.InvalidURL)) }
            guard let url = url else { completion(.failure(.InvalidURL)); return }
            guard let data = try? Data(contentsOf: url) else { completion(.failure(.InvalidURL)); return }
            
            // temp url의 data를 cachedImageFileURL에 저장
            if let cachedImageFileURL = cachedImageFileURL {
                try? FileManager.default.moveItem(at: url, to: cachedImageFileURL)
            }
            
            completion(.success(data))
        }.resume()
    }
}
