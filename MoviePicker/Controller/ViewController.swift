//
//  ViewController.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/23/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    var animationView : LOTAnimationView!
    var starViews : [LOTAnimationView]!
    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var minimumRatingLabel: UILabel!
    
    @IBOutlet var starButtons: [AnimatedButtons]!
    
    @IBOutlet weak var starStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var starStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var getResultsBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var clearResultsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromTextFieldHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var toYear: UITextField!
    @IBOutlet weak var fromyear: UITextField!
    
    @IBOutlet weak var selectedLanguage: UILabel!
    @IBOutlet weak var selectedCertificate: UILabel!
   
    @IBOutlet weak var selectedGenresLabel: UILabel!
    @IBOutlet weak var selectedActorsLabel: UILabel!
    @IBOutlet weak var selected: UILabel!
    
    @IBOutlet weak var resultViewTopDistance: NSLayoutConstraint!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var newSearchBtn: UIButton!
    @IBOutlet weak var showAllBtn: UIButton!
    @IBOutlet weak var showRandomBtn: UIButton!
    

    @IBOutlet weak var selectedLanguageBtn: UIButton!
    @IBOutlet weak var selectedMcBtn: UIButton!
    @IBOutlet weak var selectedGenresBtn: UIButton!
    @IBOutlet weak var selectedActorsBtn: UIButton!
    
    
    @IBOutlet weak var clearFilterBtn: UIButton!
    @IBOutlet weak var getResultsBtn: UIButton!
    
    
    @IBOutlet weak var btnsHeightConstraint: NSLayoutConstraint!    
    let myCustomFont = UIFont(name: "AvenirNext-DemiBold", size: UIScreen.main.bounds.height * 0.026)
    var movieResults = [Movie]()
    var minimumRating = 0
    
    @IBAction func starButtonsClicked(_ sender: UIButton) {
        print(sender.tag)
        self.minimumRating = sender.tag
        for button in starButtons {
            if button.tag <= sender.tag {
                print(button.starView)
                button.setImage(nil, for: .normal)
                button.starView.alpha = 1.0
                button.starView.play()
            } else {
                button.starView.alpha = 0.0
                button.setImage(#imageLiteral(resourceName: "star (2).png"), for: .normal)
            }
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes : [NSAttributedStringKey:Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "AvenirNext-Bold", size: 19)!]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.clipsToBounds = true
        self.addTapRecognizer()
        self.configureView()
        self.addLottieView()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LanguageSelectorVC") as! LanguageSelectorVC
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true, completion: {
            
//            DataService.instance.setMinimumRating(rating: self.minimumRating.text)
        })
        
    }
    
    @IBAction func selectLanguageBtnPressed(_ sender: Any) {
        
        let languageSelectorVC = self.storyboard?.instantiateViewController(withIdentifier: "LanguageSelectorVC") as! LanguageSelectorVC
        self.modalTransitionStyle = .coverVertical
        self.present(languageSelectorVC, animated: true, completion: nil)
    }
    

    @IBAction func selectMCBtnPressed(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MCSelectorVC") as! MCSelectorVC
                nextVC.modalTransitionStyle = .coverVertical
                present(nextVC, animated: true, completion:nil)
    }
    
    @IBAction func selectGenreBtnPressed(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "GenreSelectorVC") as! GenreSelectorVC
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func selectActorBtnPressed(_ sender: Any) {
        guard let presentedVC = self.storyboard?.instantiateViewController(withIdentifier: "ActorSearchVC") as? ActorSearchVC else { return }
        presentedVC.modalTransitionStyle = .coverVertical
        present(presentedVC, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func newSearchBtnPressd(_ sender: UIButton) {
        self.backgroundView.alpha = 1.0
        self.backgroundView.isUserInteractionEnabled = true
        self.resultViewTopDistance.constant  = 1000
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func showAllBtnPressed(_ sender: Any) {
        if self.movieResults.count != 0{
        self.performSegue(withIdentifier: "showAllMovieResults", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
        if segue.identifier == "showAllMovieResults" {
            let destinationVC = segue.destination as! MovieResultsVC
            destinationVC.movies = movieResults
        }
//        if segue.identifier == "showRandom" {
//            let destinationVC = segue.destination as! MovieDetailVC
//            destinationVC.movies = movieResults
//        }
        if segue.identifier == "showMovieInfo"{
            print("preparing for random segue")
            let destinationVC = segue.destination as! MovieInfoVC
            movieResults.shuffle()
            destinationVC.movies = movieResults
            destinationVC.isRandomView = true
        }
    }
    
    @IBAction func showRandomBtnPressed(_ sender: Any) {
        if self.movieResults.count != 0{
            self.performSegue(withIdentifier: "showMovieInfo", sender: self)
        }
    }
    func addLottieView(){
        animationView = LOTAnimationView(name: "loader")
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        animationView.animationSpeed = 2
        animationView.alpha = 0.0
        self.view.addSubview(animationView)
        
        
    }
    func startLottieView(){
        animationView.alpha = 1.0
        animationView.play()
    }
    func stopLottieView(){
        animationView.stop()
        animationView.alpha = 0.0
    }
    func configureView(){
        
        let screenHeight = UIScreen.main.bounds.height
        let starSize = 0.04 * screenHeight
        let buttonsHeight = screenHeight * 0.05
        self.starStackViewHeightConstraint.constant = starSize
        self.starStackViewWidthConstraint.constant = starSize * 6
        
        self.fromTextFieldHeightConstraint.constant = 0.0407 * screenHeight
        
        self.getResultsBtnHeightConstraint.constant = buttonsHeight
        self.clearResultsHeightConstraint.constant = buttonsHeight
        
        self.toLabel.font = myCustomFont
        self.formLabel.font = myCustomFont
        self.minimumRatingLabel.font = myCustomFont
        self.selectedLanguageBtn.titleLabel?.font = myCustomFont
        self.selectedActorsBtn.titleLabel?.font = myCustomFont
        self.selectedGenresBtn.titleLabel?.font = myCustomFont
        self.selectedMcBtn.titleLabel?.font = myCustomFont
        self.selectedCertificate.font = myCustomFont
        self.selectedLanguage.font = myCustomFont
        self.selectedActorsLabel.font = myCustomFont
        self.selectedGenresLabel.font = myCustomFont
        
        
        self.btnsHeightConstraint.constant = buttonsHeight
        self.resultView.layer.cornerRadius = 10.0
        self.resultView.clipsToBounds = true
        self.showAllBtn.layer.cornerRadius = 7.0
        self.showAllBtn.clipsToBounds = true
        self.newSearchBtn.layer.cornerRadius = 7.0
        self.newSearchBtn.clipsToBounds = true
        self.showRandomBtn.layer.cornerRadius = 7.0
        self.showRandomBtn.clipsToBounds = true
        self.clearFilterBtn.layer.cornerRadius = 7.0
        self.clearFilterBtn.clipsToBounds = true
        self.getResultsBtn.layer.cornerRadius = 7.0
        self.getResultsBtn.clipsToBounds = true
        self.selectedMcBtn.layer.cornerRadius = 7.0
        self.selectedMcBtn.clipsToBounds = true
        self.selectedLanguageBtn.layer.cornerRadius = 7.0
        self.selectedLanguageBtn.clipsToBounds = true
        self.selectedGenresBtn.layer.cornerRadius = 7.0
        self.selectedGenresBtn.clipsToBounds = true
        self.selectedActorsBtn.layer.cornerRadius = 7.0
        self.selectedActorsBtn.clipsToBounds = true
        
        
        
        
    }
    @IBAction func clearFilterBtnPressed(_ sender: Any) {
        self.selectedLanguage.text = "No Language Selected"
        self.selectedCertificate.text = "No Certificate Selected"
        self.selectedGenresLabel.text = "No Genres Selected"
        self.selectedActorsLabel.text = "No Actors Selected"
        
        for button in starButtons {
                button.starView.alpha = 0.0
                button.setImage(#imageLiteral(resourceName: "star (2)"), for: .normal)
            }
        
        DataService.instance.clearAllFields()
        
        
    }
    
    @IBAction func getResultsBtnPressed(_ sender: UIButton) {
        
        animationView.alpha = 1.0
        animationView.play()
        
        self.movieResults = [Movie]()
        if self.minimumRating != 0{
            DataService.instance.setMinimumRating(rating: "\(self.minimumRating)")
        }
        if self.fromyear.text != ""{
            DataService.instance.setFromYear(year: self.fromyear.text)
        }
        if self.toYear.text != ""{
            DataService.instance.setToYear(year: self.toYear.text)
        }
        getAllPages(pageNumber: 1)
        
        }
    
    
    func getAllPages(pageNumber: Int){
        DataService.instance.getMovies(forUrl: DataService.instance.createDiscoverUrl(forPage: pageNumber)) { (movies,cPage,tPages)  in
            self.movieResults += movies
            if movies.count == 0{
                self.stopLottieView()
                self.activatePopUpView()
            } else {
            let page = Int(cPage)!
            let pages = Int(tPages)!
            if pages <= 3{
                if page < pages{
                    self.getAllPages(pageNumber: page+1)
                }else{
                    self.stopLottieView()
                    self.activatePopUpView()
                    return
                }
            }
            else{
                if page < 3{
                    self.getAllPages(pageNumber: page + 1)
                } else {
                    self.stopLottieView()
                    self.activatePopUpView()
                    return
                }
            }
            }
        }
        
    }
    
    func addTapRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
  @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    func activatePopUpView(){
        self.resultLabel.text = "\(self.movieResults.count) results found"
        self.resultViewTopDistance.constant = 100
        self.backgroundView.alpha = 0.5
        self.backgroundView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

}


