//
//  MovieInfoTVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 3/2/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class MovieInfoTVC: UITableViewController {
    
    var movie: Movie!
    var cast = [Cast]()
    var selectedCollectionViewCellIndex : Int!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var posterImageViewWidth: NSLayoutConstraint!
    @IBOutlet var starButtons: [UIButton]!
    
    @IBOutlet weak var starStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var starStackViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var directorTag: UILabel!
    @IBOutlet weak var writerTag: UILabel!
    
    @IBOutlet weak var storyLineCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        configureMovieInfo { (sucess) in
            
        }
        collectionViewSetup()
        tableViewCellSetup()
        
        
        
        }
        
    func  configureMovieInfo(completion:@escaping (Bool)->()){
       
                DataService.instance.getExtraMovieData(forId: self.movie.id) { (runtime, genres) in
                    DataService.instance.getCastFor(forMovieId: self.movie.id, completion: { (castArray,crewDict)  in
                        self.backdropImageView.image = self.movie.backdropImage
                        self.profileImageView.image = self.movie.posterImage
                        self.titleLabel.text = self.movie.title + " (" + self.movie.releaseDate[...self.movie.releaseDate.index(self.movie.releaseDate.startIndex, offsetBy: 3)] + ")"
                        let time = Int(runtime) ?? 0
                        self.durationLabel.text = "\(time/60)h \(time%60)min"
                        self.genresLabel.text = genres.map({$0.name}).joined(separator: ",")
                        self.releaseDate.text = self.convertDateStringToDifferentFormat(dateString: self.movie.releaseDate)
                        self.voteCountLabel.text = "(" + self.movie.voteCount + ")"
                        self.configureStarButtons(forRating: self.movie.rating)
                        self.overviewLabel.text = self.movie.overview
                        var crew = crewDict
                        if crewDict.count == 2{
                        self.directorLabel.text = crew.popFirst()?.value
                        self.writerLabel.text = crew.popFirst()?.value
                        }else if crew.count == 1{
                            self.directorLabel.text = crew.popFirst()?.value
                            self.writerLabel.text = "no data"
                        }else {
                            self.directorLabel.text = "no data"
                            self.writerLabel.text = "no data"
                        }
                        self.cast = castArray
                        //                    self.starsLabel.text = castArray[...castArray.index(castArray.startIndex, offsetBy: 1)].map({$0.actorName}).joined(separator: ",")
                        self.collectionView.reloadData()
                        completion(true)
                        
                    })
                    
                }
    }
    func tableViewCellSetup(){
        let screenWidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        self.posterImageViewWidth.constant = 0.4 * screenWidth
        self.starStackViewHeight.constant = 0.02 * screenheight
        self.starStackViewWidth.constant = 0.1 * screenheight
        
        let smallerFont = UIFont(name: "AvenirNext-Regular", size: screenheight * 0.015)
        
        self.releaseDate.font = smallerFont
        self.durationLabel.font = smallerFont
        
        self.voteCountLabel.font = smallerFont
        self.writerLabel.font = smallerFont
        self.directorLabel.font = smallerFont
        
        
        
    }
    func convertDateStringToDifferentFormat(dateString: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: dateString)!
        
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter.string(from: myDate)
    }
    
    func configureStarButtons(forRating rating :String){
        for i in 0..<Int(ceil(Float(rating)!/2)){
            self.starButtons[i].setImage(#imageLiteral(resourceName: "full-star"), for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if indexPath.row == 0 {
            return CGFloat(screenHeight * 0.3)
        }else if indexPath.row == 1{
            return CGFloat(screenHeight * 0.35)
        }else if indexPath.row == 3{
            return CGFloat(screenHeight * 0.25)
        }else{
            return CGFloat(screenHeight * 0.25)
        }
    }
    
    func collectionViewSetup(){
        
        let flow = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing: CGFloat = 3
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10)
        let numberOfItemsVisible: CGFloat = 4
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(numberOfItemsVisible - 1)-10
        flow.itemSize = CGSize(width: floor(width/numberOfItemsVisible), height: 1.515*floor(width/numberOfItemsVisible))
        flow.minimumInteritemSpacing = 3
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "actorInfo" {
            print("entered segue")
            guard let actorInfoVC = segue.destination as? CastInfoVC else { return }
            actorInfoVC.actorName = self.cast[selectedCollectionViewCellIndex].actorName
        }
    }
}

extension MovieInfoTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cast.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as? CastCell else { return UICollectionViewCell()}
        DataService.instance.getImage(forPath: self.cast[indexPath.item].profilePath) { (image) in
            cell.castImageView.image = image
            cell.castNameLbl.text = self.cast[indexPath.item].actorName
            cell.castImageView.layer.cornerRadius = 15.0
            cell.castImageView.clipsToBounds = true
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected row at index \(indexPath.item)")
        print(self.cast[indexPath.item].actorName)
        selectedCollectionViewCellIndex = indexPath.item
        self.performSegue(withIdentifier: "actorInfo", sender: self)
    }
    
}
