//
//  ActorSearchVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/23/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class ActorSearchVC: UIViewController {

    @IBOutlet weak var actorNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addedActorsDisplayViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addedActorsDisplayView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var actorArray = [Actor]()
    var selectedActors = [Actor]()
    var selectedActorImages = [UIImage]()
    var didSelectARow = false
    var selectedStatusOfActorCells = [Bool]()
    var currentIndexPath: IndexPath?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.actorNameTextField.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.actorNameTextField.addTarget(self, action: #selector(ActorSearchVC.textFieldDidChange), for: .editingChanged)
        configureView()
        // Do any additional setup after loading the view.
    
    }
    
    
    func configureView(){
        self.addedActorsDisplayView.layer.cornerRadius = 5.0
        self.addedActorsDisplayView.clipsToBounds = true
        
        self.actorNameTextField.layer.cornerRadius = 5.0
        self.actorNameTextField.clipsToBounds = true
        
        self.addedActorsDisplayViewHeightConstraint.constant = 0
    }

    @objc func textFieldDidChange(){
    
        if actorNameTextField.text == "" {
            self.actorArray = []
            self.tableView.reloadData()
        } else {
            DataService.instance.getActors(forName: actorNameTextField.text!, completion: { (actors) in
                self.actorArray = actors
                self.tableView.reloadData()
            })
        }
        
    }
    
   
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if selectedActors.count != 0{
        
        let nav = self.presentingViewController as! UINavigationController
        let presentingVC = nav.viewControllers.first as! ViewController
        presentingVC.selectedActorsLabel.text = self.selectedActors.map({$0.name}).joined(separator: ",")
        self.dismiss(animated: true, completion: nil)
        DataService.instance.setSelectedActors(actors: self.selectedActors.map({$0.id}))

        }
        
    }
    
   
    @IBAction func BackBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ActorSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actorArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorCell", for: indexPath) as? ActorCell else { return UITableViewCell()}
        let actor = self.actorArray[indexPath.row]
        print(actor.posterPath)
        DataService.instance.getImage(forPath: actor.posterPath) { (image) in
            cell.configureCell(name: actor.name, image: image)
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.didSelectARow {
         self.addedActorsDisplayViewHeightConstraint.constant += 70
        UIView.animate(withDuration: 0.5) {
           self.view.layoutIfNeeded()
            
        }
        self.didSelectARow = true
        }
        for actor in selectedActors{
            if actorArray[indexPath.row].id == actor.id{
                return
            }
        }
        selectedActors.append(actorArray[indexPath.row])
        //collectionView.reloadData()
        collectionView.insertItems(at: [IndexPath(row: selectedActors.count-1, section:0)])
        collectionView.scrollToItem(at: IndexPath(row: selectedActors.count-1, section:0), at: .left, animated: true)
    
 }
}

extension ActorSearchVC: UITextFieldDelegate{
    
}
extension ActorSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedActors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedActorCell", for: indexPath) as? AddedActorCell else { return UICollectionViewCell()}
        self.selectedStatusOfActorCells.append(false)
        cell.cancelIcon.isHidden = true
        DataService.instance.getImage(forPath: self.selectedActors[indexPath.row].posterPath) { (image) in
            cell.actorImage.image = image
            cell.actorImage.layer.cornerRadius = 5.0
            cell.actorImage.clipsToBounds = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! AddedActorCell
        if self.selectedStatusOfActorCells[indexPath.row] {
            
            self.selectedActors.remove(at: indexPath.row)
            self.selectedStatusOfActorCells.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            if self.selectedActors.count == 0{
                self.didSelectARow = false
                self.addedActorsDisplayViewHeightConstraint.constant  = 0
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }else{
        cell.cancelIcon.isHidden = false
        self.selectedStatusOfActorCells[indexPath.row] = true
        }
    }
}
