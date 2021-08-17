//
//  MovieTableViewCell.swift
//  HS Movie App
//
//  Created by Jigneshkumar Patil on 2021/08/16.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var votingAverageLabel: UILabel!
    @IBOutlet weak var votingAverageDoubleLabel: UILabel!
    var storeMoviePosterURL: String!
    
}
