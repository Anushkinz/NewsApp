//
//  APICaller.swift
//  News
//
//  Created by anushkinz on 28/6/21.
//
// newsapi.org api key fe2c70e90efc49fe835d9497179b8f63
import Foundation

//let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=fe2c70e90efc49fe835d9497179b8f63"
final class APICaller{
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=fe2c70e90efc49fe835d9497179b8f63")
        
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping (Result<[Articles],Error>)-> Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles:\(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
                
            }
        }
        task.resume()
    }
}

/// models

struct APIResponse: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
