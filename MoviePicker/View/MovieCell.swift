//
//  MovieCell.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/27/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieCastLabel: UILabel!
    
    func configureCell(image:UIImage, title:String, cast:String){
        self.movieImageView.image = image
        self.movieImageView.contentMode = .scaleAspectFill
        self.movieTitle.text = title
        self.movieCastLabel.text = cast
        self.movieImageView.layer.cornerRadius = 2.0
        self.movieImageView.clipsToBounds = true
    }
}
