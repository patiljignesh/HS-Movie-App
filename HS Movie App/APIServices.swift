//
//  API Services.swift
//  HS Movie App
//
//  Created by Jigneshkumar Patil on 2021/08/16.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovieList(_ apiServices: APIServices, movieResult: [Results])
    func didFailWithError(error: Error)
}

struct APIServices {
    
    private let movieURLString = "https://api.themoviedb.org/3/movie/popular?api_key=63f52ce00e1763ce789b2bcb1d34f124&language=en-US&page=1"
    
    var delegate: MovieManagerDelegate?
    
    public func getAllPopularMovies() {
        performRequest(with: movieURLString)
    }
    
    private func performRequest(with movieURLString: String) {
        
        if let movieURL = URL(string: movieURLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: movieURL) { data, response,error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let movieModel = parseJSON(safeData) {
                        delegate?.didUpdateMovieList(self, movieResult: movieModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON( _ movieData: Data) -> [Results]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            let decodedDataSimple = decodedData.results
            return decodedDataSimple
        } catch {
            return nil
        }
    }
        
}
