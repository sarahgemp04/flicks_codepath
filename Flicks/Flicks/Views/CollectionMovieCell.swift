//
//  CollectionMovieCell.swift
//  Flicks
//
//  Created by Sarah Gemperle on 11/25/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AlamofireImage

class CollectionMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePosterImg: UIImageView!
    
    var posterImageURL: URL?
    var movie: [String: Any]?
    
    
    func initCell(movie: [String: Any]) {
        
        let posterPathString = movie["poster_path"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        posterImageURL = URL(string: baseURL + posterPathString)
        
        moviePosterImg.af_setImage(withURL: posterImageURL!)
        
    }

}
