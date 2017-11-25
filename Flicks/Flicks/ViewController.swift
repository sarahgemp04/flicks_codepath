//
//  ViewController.swift
//  Flicks
//
//  Created by Sarah Gemperle on 11/24/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
    var movies: [[String: Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.startAnimating()

        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        loadMovies()
        
    }
    
    func loadMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                let alertController = UIAlertController(title: "Server Error", message: "Could not load Movies. Please check your connection.", preferredStyle: .alert)
                // create an OK action
                let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.loadMovies()
                }
                // add the OK action to the alert controller
                alertController.addAction(TryAgainAction)
                
                self.present(alertController, animated: true) {}
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                print(dataDictionary["results"] as! [[String: Any]])
                
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        if let movies = movies {
            cell.initCell(movie: movies[indexPath.row])
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 10
        }

    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        activityIndicator.startAnimating()
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                let alertController = UIAlertController(title: "Server Error", message: "Could not load Movies. Please check your connection.", preferredStyle: .alert)
                // create an OK action
                let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.loadMovies()
                }
                // add the OK action to the alert controller
                alertController.addAction(TryAgainAction)
                
                self.present(alertController, animated: true) {}
                
                refreshControl.endRefreshing()
                
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                print(dataDictionary["results"] as! [[String: Any]])
                
                self.movies = dataDictionary["results"] as! [[String: Any]]
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

