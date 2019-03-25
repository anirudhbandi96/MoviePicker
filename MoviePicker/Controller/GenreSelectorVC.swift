//
//  GenreSelectorVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/24/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class GenreSelectorVC: UIViewController {
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    var genresArray = [Genre]()
    var selectedGenresArray = [Genre]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionVIew.delegate = self
        self.collectionVIew.dataSource = self
        collectionViewSetup()
        DataService.instance.getGenreData { (genres) in
            self.genresArray = genres
            self.collectionVIew.reloadData()
        }
        // Do any additional setup after loading the view.
        
       
        
        
    }
    func collectionViewSetup(){
        
        let flow = collectionVIew?.collectionViewLayout as! UICollectionViewFlowLayout // If you create collectionView programmatically then just create this flow by UICollectionViewFlowLayout() and init a collectionView by this flow.
        
        let itemSpacing: CGFloat = 3
        let itemsInOneLine: CGFloat = 3
        flow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1)-10 //collectionView.frame.width is the same as  UIScreen.main.bounds.size.width here.
        flow.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
        flow.minimumInteritemSpacing = 3
        flow.minimumLineSpacing = 3
        
    }

    @IBAction func nextButton(_ sender: Any) {
        
       
        if selectedGenresArray.count != 0{
        let nav = self.presentingViewController as! UINavigationController
        let presentingVC = nav.viewControllers.first as! ViewController
        let genreString = self.selectedGenresArray.map({$0.name!})
        DataService.instance.setSelectedGenres(genres: self.selectedGenresArray.map({ $0.id}) )
        presentingVC.selectedGenresLabel.text = genreString.joined(separator: ",")
        dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GenreSelectorVC: UICollectionViewDelegate , UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genresArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as? GenreCell else { return UICollectionViewCell()}
        cell.genreLabel.text = self.genresArray[indexPath.row].name
        cell.tickImage.isHidden = true
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GenreCell
        
        if cell.tickImage.isHidden {
            cell.tickImage.isHidden = false
            self.selectedGenresArray.append(genresArray[indexPath.item])
        }else{
            cell.tickImage.isHidden = true
            //self.selectedGenresArray.remove(at: self.selectedGenresArray.index(of: genresArray[indexPath.item].id)!)
            self.selectedGenresArray =  self.selectedGenresArray.filter({
                $0.id != genresArray[indexPath.item].id
            })
        }
    }
    
}
