//
//  MovieInfoVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 3/2/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class MovieInfoVC: UIViewController {
    
    var movies = [Movie]()
    var indexOfMovie: Int = -1
    var movie: Movie!
    var isRandomView: Bool = false
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerViewToBtnConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMeAnotherBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue to table view")
        if segue.identifier == "movieInfo" {
            guard let tableVC = segue.destination as? MovieInfoTVC else { return }
            if movie == nil {
                configureNextMovie()
            }
            tableVC.movie = self.movie
        }
        
    }
    func configureNextMovie(){
        self.indexOfMovie += 1
        print(indexOfMovie)
        print(self.movies.count)
        self.movie = self.movies[indexOfMovie%movies.count]
        
    }
    @IBAction func showMeAnotherBtnPressed(_ sender: Any) {
        
        self.showMeAnotherBtn.isEnabled = false
        print("inside button clicked")
        let childView =  self.childViewControllers.first as! MovieInfoTVC
        configureNextMovie()
        childView.movie = self.movie
        childView.configureMovieInfo { (success) in
            if success {
                self.showMeAnotherBtn.isEnabled = true
            }
        }
       
    }
    
    func configureView(){
        if self.isRandomView{
            self.containerViewToBtnConstraint.constant = 50
            self.showMeAnotherBtn.layer.cornerRadius = 5.0
            self.showMeAnotherBtn.clipsToBounds = true
            self.showMeAnotherBtn.isHidden = false
        }else {
            self.showMeAnotherBtn.isHidden = true
        }
    }
}

