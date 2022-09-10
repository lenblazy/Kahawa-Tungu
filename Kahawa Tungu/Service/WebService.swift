//
//  WebService.swift
//  Kahawa Tungu
//
//  Created by LenoxBrown on 10/09/2022.
//

import Foundation

enum NetworkError: Error{
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String{
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable>{
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource{
    init(url: URL){
        self.url = url
    }
}

class WebService{
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void){
        //
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //
            guard let safeData = data, error == nil else{
                completion(.failure(.domainError))
                return
            }
            
            do{
                let result = try JSONDecoder().decode(T.self, from: safeData)
                
                DispatchQueue.main.async {
                    completion(.success(result))
                }
                
            }catch{
                completion(.failure(.decodingError))
            }
            
            
        }.resume()
        
    }
    
}
