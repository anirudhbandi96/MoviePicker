//
//  MovieResultsVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/27/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class MovieResultsVC: UIViewController {

    var movies = [Movie]()
    var selectedRow : Int!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }


}

extension MovieResultsVC : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
            DataService.instance.getCastFor(forMovieId: movie.id, completion: { (castArray,dict)  in
                let i = min(2, castArray.count)
                var releaseDateString = ""
                if movie.releaseDate != ""{
                    releaseDateString += " (" + movie.releaseDate[..<movie.releaseDate.index(movie.releaseDate.startIndex, offsetBy: 4)] + ")"
                }
                cell.configureCell(image: movie.posterImage, title: movie.title + releaseDateString, cast: (castArray[..<i].map({$0.actorName})).joined(separator:", "))
            })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as! MovieCell
        print("selected cell title :" + cell.movieTitle.text!)
        print("selected movie:" + self.movies[selectedRow].title)
        self.performSegue(withIdentifier: "showMovie", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovie"{
            print(segue.destination)
            let destinationVC = segue.destination as! MovieInfoVC
            destinationVC.movie = self.movies[self.selectedRow]
        }
    }
}
