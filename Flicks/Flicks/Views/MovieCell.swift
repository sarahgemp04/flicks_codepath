//
//  MovieCell.swift
//  Flicks
//
//  Created by Sarah Gemperle on 11/24/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class MovieCell: UITableViewCell {

    var posterImageURL: URL?
    var movie: [String: Any]?
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initCell(movie: [String: Any]) {
        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String
        
        let posterPathString = movie["poster_path"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500"
        posterImageURL = URL(string: baseURL + posterPathString)
        
        posterImageView.af_setImage(withURL: posterImageURL!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
