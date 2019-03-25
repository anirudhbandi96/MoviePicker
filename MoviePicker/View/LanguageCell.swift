//
//  LanguageCell.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/25/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
