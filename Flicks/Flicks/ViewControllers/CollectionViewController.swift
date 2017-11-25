//
//  CollectionViewController.swift
//  Flicks
//
//  Created by Sarah Gemperle on 11/25/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [[String: Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        activityIndicator.startAnimating()
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)
        
        loadMovies()
        
    }
    
    func loadMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/396422/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionMovieCell
        
        if let movies = movies {
            cell.initCell(movie: movies[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
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
                
                self.collectionView.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
