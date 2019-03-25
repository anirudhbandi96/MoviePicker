//
//  Movie.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/23/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation
import UIKit

struct Movie{
    public private(set) var id:String!
    public private(set) var title:String!
    public private(set) var genreIds:[String]!
    public private(set) var overview:String!
    public private(set) var posterImage:UIImage!
    public private(set) var backdropImage:UIImage!
    public private(set) var rating:String!
    public private(set) var voteCount:String!
    public private(set) var releaseDate:String!
}
