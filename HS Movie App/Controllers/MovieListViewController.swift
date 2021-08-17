//
//  ViewController.swift
//  HS Movie App
//
//  Created by Jigneshkumar Patil on 2021/08/15.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var apiServiceManager = APIServices()
    public var apiServices = APIServices()
    private var localMovieResult: [Results]?
    var staticMoviePosterPath: String = "https://image.tmdb.org/t/p/w200"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiServiceManager.delegate = self
        getMoviedata()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieTableViewCellID")
        
        
    }
}

//MARK: - API Calls

extension MovieListViewController {
    public func getMoviedata() {
        apiServiceManager.getAllPopularMovies()
    }
}

//MARK: - TableView DataSource & Delegate

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let safeLocalMovieResult = localMovieResult {
            return safeLocalMovieResult.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCellID", for: indexPath) as! MovieTableViewCell
        if let safeLocalMovieResult = localMovieResult {
            cell.titleLabel?.text = safeLocalMovieResult[indexPath.row].title
            cell.releaseDateLabel.text = safeLocalMovieResult[indexPath.row].release_date
            cell.votingAverageDoubleLabel.text = doubleToPercentage(for: safeLocalMovieResult[indexPath.row].vote_average)
            let tempMoviePosterImagePath =  staticMoviePosterPath + safeLocalMovieResult[indexPath.row].poster_path
            cell.moviePosterImageView.imageFromServerURL(urlString: tempMoviePosterImagePath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - MovieManagerDelegate

extension MovieListViewController: MovieManagerDelegate {
    
    func didUpdateMovieList(_ apiServices: APIServices, movieResult: [Results]) {
        DispatchQueue.main.async {
            self.localMovieResult = movieResult
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - ModelView Decouple

extension MovieListViewController {
    public func doubleToPercentage(for doubleVoteRating: Double) -> String?{
        
        return String(format: "%.2f", (doubleVoteRating * 10)) + "%"
    }
}


//MARK: - Fetch Image From URL

extension UIImageView {
    
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
