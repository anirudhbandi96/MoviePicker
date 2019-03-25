//
//  GenreCell.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/24/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var tickImage: UIImageView!
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 5.0
        self.clipsToBounds  = true
        
        tickImage.layer.cornerRadius = 12.5
        tickImage.clipsToBounds = true
    }
    
}
