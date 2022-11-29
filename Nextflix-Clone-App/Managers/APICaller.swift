//
//  APICaller.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/28/22.
//

import Foundation

struct Constants {
    
    static let API_KEY = "ad3e6817da2323a506b0eb7bd8a86615"
    
    static let baseURL = "https://api.themoviedb.org"
    
}

enum APIError: Error {
    
    case failedToGetData
    
}

class APICaller {
    
    static let shared = APICaller()
    
    // Escaping because it gets called inside .dataTask method that it outside the getTrendingMovies  function's scope.
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(Response.self, from: data)
                
                completion(.success(result.results))
                
            } catch {
                
                completion(.failure(APIError.failedToGetData))
                
            }
            
        }
        
        // Finishing off the request.
        
        task.resume()
        
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(Response.self, from: data)
                
                completion(.success(result.results))

            } catch {
                
                completion(.failure(APIError.failedToGetData))
                
            }
            
        }
        
        task.resume()
        
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(Response.self, from: data)
                
                completion(.success(result.results))

            } catch {
                
                completion(.failure(APIError.failedToGetData))
                
            }
            
        }
        
        task.resume()
        
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(Response.self, from: data)
                
                completion(.success(result.results))

            } catch {
                
                completion(.failure(APIError.failedToGetData))
                
            }
            
        }
        
        task.resume()
        
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(Response.self, from: data)
                
                completion(.success(result.results))

            } catch {
                
                completion(.failure(APIError.failedToGetData))
                
            }
            
        }
        
        task.resume()
        
    }
    
}
