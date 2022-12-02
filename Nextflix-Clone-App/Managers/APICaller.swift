//
//  APICaller.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/28/22.
//
/*
 Result<[Title], Error> ---> means return array of titles if successful. Otherwise, return error. That's why we write completion(.success(result.results)) or completion(.failure(APIError.failedToGetData)) and it becomes esentially the same thing as return results or return error. Just a sintax thing.
 */

import Foundation

struct Constants {
    
    static let API_KEY = "ad3e6817da2323a506b0eb7bd8a86615"
    
    static let baseURL = "https://api.themoviedb.org"
    
    static let Youtube_API_KEY = "AIzaSyD6ZBV5DdeB2lfclsW7TUGhJi9DmtrqaNU"
    
    static let baseYoutubeURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
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
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
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
    
    func searchMovies(with query: String, completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        // Special characters are converted by a browser into a format that can be processed. Example: '*' might be encoded into '%20'
        // We use .addingPercentEncoding so that if our String input inside the url has special characters which are unreadable by the host, those chars can then be converted into readable ones.
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
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
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseYoutubeURL)q=\(query)&key=\(Constants.Youtube_API_KEY )") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(result.items[0]))

            } catch {
                
                completion(.failure(APIError.failedToGetData))
                
            }
            
        }
        
        task.resume()
        
    }
    
}
