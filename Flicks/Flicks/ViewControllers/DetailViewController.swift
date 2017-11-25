//
//  DetailViewController.swift
//  Flicks
//
//  Created by Sarah Gemperle on 11/24/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var movie: [String: Any]?
    var backDropImageURL: URL?
    var mainImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
        self.mainImageView.layer.cornerRadius = 50
        self.mainImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.mainImageView.layer.borderWidth = 2
        
        if let movie = movie {

            titleLabel.text = movie["title"] as? String
            descriptionLabel.text = movie["overview"] as? String
            
            let posterPathString = movie["poster_path"] as! String
            let backdropString = movie["backdrop_path"] as! String
            let baseURL = "https://image.tmdb.org/t/p/w500"
            mainImageURL = URL(string: baseURL + posterPathString)
            backDropImageURL = URL(string: baseURL + backdropString)
            
            mainImageView.af_setImage(withURL: mainImageURL!)
            backDropImageView.af_setImage(withURL: backDropImageURL!)
            titleLabel.text = movie["title"] as? String
            descriptionLabel.text = movie["overview"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
        }
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
