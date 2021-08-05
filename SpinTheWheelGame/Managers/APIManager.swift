//
//  APIManager.swift
//  SpinTheWheelGame
//
//  Created by Shane Bersiek on 8/2/21.
//


import Foundation

struct APIManager {
   
    enum HttpMethod: String {
        case get
    }
    
    fileprivate let baseUrl = "http://mockbin.org/bin"
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "mockbin.org"
        return urlComponents
    }
    
    func fetchAllPosts(completion: @escaping (Result<[Reward], Error>) -> ()) {
        var urlComponents = self.urlComponents
        urlComponents.path = "/bin/dc24c4de-102f-49bf-9c80-9ed52d4ea7f6"
        guard let url = urlComponents.url else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    let rewards = try JSONDecoder().decode([Reward].self, from: data!)
                    
                    completion(.success(rewards))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }.resume()
        }
    }
}
