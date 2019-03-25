//
//  ActorCell.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/23/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {

    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var actorProfileImage: UIImageView!
  
    func configureCell(name: String, image: UIImage){
        self.actorName.text = name
        self.actorProfileImage.image = image
        self.actorProfileImage.layer.cornerRadius = 4.0
        self.actorProfileImage.clipsToBounds = true
    }
    

}
