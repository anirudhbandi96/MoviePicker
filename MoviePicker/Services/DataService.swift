//
//  DataService.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/23/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import SwiftSoup

class DataService{
    static let instance = DataService()
    
    private var selectedActors : [String]?
    private var year: String?
    private var fromYear: String?
    private var toYear: String?
    private var minimumRating : String?
    private var selectedLanguage: String?
    private var selectedGenres: [String]?
    private var selectedCertificate: [String]?
    private var genreDict: [Genre]?
    
    
    func setSelectedActors(actors: [String]?){
        self.selectedActors = actors
    }
    func setYear(year: String?){
        self.year = year
    }
    func setFromYear(year: String?){
        self.fromYear = year
    }
    func setToYear(year: String?){
        self.toYear = year
    }
    func setMinimumRating(rating: String?){
        self.minimumRating = rating
    }
    func setSelectedLanguage(language: String?){
        self.selectedLanguage = language
    }
    func setSelectedGenres(genres: [String]?){
        self.selectedGenres = genres
    }
    func setSelectedCertificate(certificate: [String]?){
        self.selectedCertificate = certificate
    }
//    func getGenreString(forIds ids:[String]) -> [String]{
//        if genreDict == nil {
//            DataService.instance.getGenreData(completion: { (genres) in
//                self.genreDict = genres
//            })
//        }
//        var resultedGenreString = [String]()
//        for id in ids{
//            resultedGenreString += genreDict!.filter({$0.id == id}).map({$0.name})
//        }
//        return resultedGenreString
//    }
    
    func getActors(forName name:String, completion: @escaping ([Actor]) -> ()){
        
        var actors = [Actor]()
        let url = "https://api.themoviedb.org/3/search/person?api_key=\(API_KEY)&language=en-US&query=\(name.replacingOccurrences(of: " ", with: "%20"))&page=1&include_adult=false"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    guard let results = json["results"].array else { return }
                    for item in results{
                        let name = item["name"].stringValue
                        let id = item["id"].stringValue
                        let profilePath = item["profile_path"].stringValue
                        let actor = Actor(name: name, posterPath: profilePath, id: id)
                        actors.append(actor)
                    }
                    completion(actors)
                }
                catch{
                    debugPrint(error)
                    completion([Actor]())
                }
            }else{
                print(response.result.error as Any)
                completion([Actor]())
            }
        
    }
}
    
    func getImage(forPath path:String, completion: @escaping (UIImage)->()){
        if path != ""{
        let url = "https://image.tmdb.org/t/p/w500//\(path)"
        DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        Alamofire.request(url).responseImage { (response) in
            print(url)
            print(response)
            guard let image = response.result.value else { return }
            completion(image)
        }
        }else {
            completion(UIImage(named: "default")!)
        }
    }
    
    func getGenreData(completion: @escaping ([Genre]) -> ()){
        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(API_KEY)&language=en-US"
        var genreArray = [Genre]()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    guard let genres = json["genres"].array else  {return}
                    for genre in genres {
                        genreArray.append(Genre(name: genre["name"].stringValue, id: genre["id"].stringValue))
                    }
                    completion(genreArray)
                    
                }
                catch {
                    debugPrint(error)
                }
            }
            else{
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getLanguageCodes(completion: @escaping (([[String]])->())){
        var languageCodes = [[String]]()
        Alamofire.request("https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes",method: .get).responseString { (response) in
            guard let html = response.result.value else { return  }
            do{
                let table = try SwiftSoup.parse(html).select("table#Table")
                let trs = try table.select("tr")
                var flag = 0
                for element : Element in trs{
                    var code = [String]()
                    var tds : Elements!
                    if flag == 0{
                         tds = try element.select("th")
                        flag += 1
                    }
                    else{
                        tds = try element.select("td")
                    }
                    let first = try tds.eq(2).text()
                    let second = try tds.eq(4).text()
                    code.append(first)
                    code.append(second)
                    languageCodes.append(code)
                    completion(languageCodes)
                }
                
            } catch Exception.Error( _, let message) {
                print(message)
            } catch {
                print("error")
            }
        }
    }
    
    func getCertificateData(completion: @escaping ([CountryCertificate])->()){
        let url = "https://api.themoviedb.org/3/certification/movie/list?api_key=\(API_KEY)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {
                    print("failed")
                    return }
                do{
                    
                    var certificateData = [CountryCertificate]()
                     let json = try JSON(data: data)
                     let certificationsDict = json["certifications"]
                    
                    for (country, subJson) in certificationsDict{
                        
                        var certificatesArray = [Certificate]()
                        guard let certificates = subJson.array else {return}
                        for certificate in certificates{
                            certificatesArray.append(Certificate(name: certificate["certification"].stringValue, meaning: certificate["meaning"].stringValue))
                        }
                        certificateData.append(CountryCertificate(country: country, certificates: certificatesArray))
                    }
                    completion(certificateData)
                    
                }catch{
                    print(error)
                }
            }else{
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getCountryCodeToNameConversionDict(completion: @escaping ([String:String])->()){
        
        var countryCodeToNamesDict = [String:String]()
        Alamofire.request("https://en.wikipedia.org/wiki/ISO_3166-1",method: .get).responseString { (response) in
            guard let html = response.result.value else { return  }
            do{
                let tables = try SwiftSoup.parse(html).select("table.wikitable")
                let table = tables.eq(1)
                let trs = try table.select("tr")
                for element : Element in trs{
                    let tds = try element.select("td")
                    let first = try tds.eq(0).text()
                    let second = try tds.eq(1).text()
                    countryCodeToNamesDict[second] = first
                }
                completion(countryCodeToNamesDict)
                
            } catch Exception.Error( _, let message) {
                print(message)
            } catch {
                print("error")
            }
        }
        
        
    }
    
    
    
    func getMovies(forUrl url: String, completion: @escaping (_ movies:[Movie],_ page: String,_ totalPages: String)->()){
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do{
                    print("entered do")
                    let json = try JSON(data: data)
                    let page = json["page"].stringValue
                    let totalPages = json["total_pages"].stringValue
                    
                    guard let results = json["results"].array else { return }
                    var movieArray = [Movie]()
                    print("inside get movies")
                    print(results.count)
                    if results.count > 0{
                    for result in results {
                        print("new result")
                        let id = result["id"].stringValue
                        let vote_count = result["vote_count"].stringValue
                        let vote_average = result["vote_average"].stringValue
                        let title = result["title"].stringValue
                        let poster_path = result["poster_path"].stringValue
                        let backdrop_path = result["backdrop_path"].stringValue
                        let overview = result["overview"].stringValue
                        let releaseDate = result["release_date"].stringValue
                        var genreIds = [String]()
                        guard let genreArray = result["genre_ids"].array else { return }
                        for genre in genreArray{
                            genreIds.append(genre.stringValue)
                        }
                        var backdropImage: UIImage!
                        var profileImage : UIImage!
                        DataService.instance.getImage(forPath: backdrop_path, completion: { (backdrop) in
                            DataService.instance.getImage(forPath: poster_path, completion: { (profile) in
                                backdropImage = backdrop
                                profileImage = profile
                                movieArray.append(Movie(id: id, title: title, genreIds: genreIds, overview: overview, posterImage: profileImage, backdropImage: backdropImage, rating: vote_average, voteCount: vote_count, releaseDate: releaseDate))
                                if movieArray.count == results.count {
                                    completion(movieArray, page, totalPages)
                                }
                                }
                        
                            ) } )
                    
                    }
                    }else {
                        completion(movieArray, page, totalPages)
                    }
                    
                    
                }catch{
                    print("error")
                    debugPrint(error)
                }
            }else {
                print("error")
                debugPrint(response.result.error as Any)
            }
        }
    }
    func createDiscoverUrl(forPage pageNumber:Int)->String{
        var certificationCountryString = ""
        var certificationString = ""
        var languageString = ""
        var genresString =  ""
        var castString = ""
        var ratingString = ""
        var fromYear = ""
        var toYear = ""
        
        
        if selectedCertificate != nil{
            certificationCountryString = "&certification_country=\(selectedCertificate![0])"
            certificationString = "&certification=\(selectedCertificate![1])"
        }
        if selectedLanguage != nil{
            languageString = "&with_original_language=\(selectedLanguage!)"
        }
        if selectedGenres != nil{
            genresString = "&with_genres=" + selectedGenres!.joined(separator: ",")
        }
        if self.selectedActors != nil{
            print("yes")
            castString = "&with_cast=" + self.selectedActors!.joined(separator: ",")
        }
        
        if minimumRating != nil {
            ratingString = "&vote_average.gte=" + minimumRating!
        }
       
        if self.fromYear != nil{
            fromYear = "&release_date.gte=" + self.fromYear! + "-01-01"
        }
        if self.toYear != nil{
            toYear = "&release_date.lte=" + self.toYear! + "-01-01"
        }
        return  "https://api.themoviedb.org/3/discover/movie?api_key=\(API_KEY)&language=en-US&sort_by=popularity.desc" + certificationString + certificationCountryString + languageString + genresString + castString + ratingString + fromYear + toYear + "&page=\(pageNumber)"
        
    }
    func getExtraMovieData(forId id:String, completion: @escaping (String,[Genre])->()){
        
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(API_KEY)&language=en-US"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
//                    let budget = json["budget"].stringValue
//                    var productionCompanies = [ProductionCompany]()
                    
                    var genres = [Genre]()
                    let genresJson = json["genres"].array
                    if genresJson?.count != 0 {
                    for genre in genresJson!{
                        genres.append(Genre(name: genre["name"].stringValue, id: genre["id"].stringValue))
                    }
                    //                    let tageline = json["tagline"].stringValue
                    //                    let title = json["title"].stringValue
                    //                    let voteAverage = json["vote_average"].stringValue
                    //                    let voteCount = json["vote_count"].stringValue
                    //
                    //                    let overview = json["overview"].stringValue
                    
//                    let homepage = json["homepage"].stringValue
//                    let imdbId = json["imdb_id"].stringValue
//                    let originalLanguage = json["original_language"].stringValue
//                    let populariy = json["popularity"].stringValue
//                    let productionCompaniesJson = json["production_companies"].array!
//                    for company in productionCompaniesJson{
//                        productionCompanies.append(ProductionCompany(id: company["id"].stringValue, name: company["name"].stringValue))
//                    }
//                    let releaseDate = json["release_date"]
//                    let revenue = json["revenue"].stringValue
                    }
                    let runtime = json["runtime"].stringValue
                    completion(runtime, genres)
  
                }catch{
                    debugPrint(error)
                }
            }else {
                debugPrint(response.result.error as Any)
            }
        }
    }
    func clearAllFields(){
        self.selectedActors = nil
        self.selectedCertificate = nil
        self.selectedLanguage = nil
        self.selectedGenres = nil
        self.toYear = nil
        self.fromYear = nil
    }
    
    func getCastFor(forMovieId id:String,completion: @escaping (([Cast],[String:String])->())){
        print("movieid:"+id)
        let url = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(API_KEY)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else { return }
                do{
                    let json = try JSON(data: data)
                    guard let castArray = json["cast"].array else { return }
                    var crewDict = [String:String]()
                    var castData = [Cast]()
                    for cast in castArray{
                        let castId = cast["cast_id"].stringValue
                        let character = cast["character"].stringValue
                        let creditId = cast["credit_id"].stringValue
                        let gender = cast["gender"].stringValue
                        let id = cast["id"].stringValue
                        let name = cast["name"].stringValue
                        let profilePath = cast["profile_path"].stringValue
                        castData.append(Cast(castId: castId, characterName: character, creditId: creditId, gender: gender, id: id, actorName: name, profilePath: profilePath))
                    }
                    guard let crewArray = json["crew"].array else { return }
                    if crewArray.count >= 2 {
                    for crew in crewArray[...crewArray.index(crewArray.startIndex, offsetBy: 1)]{
                        crewDict[crew["job"].stringValue] = crew["name"].stringValue
                    }
                    } else if crewArray.count == 1 {
                        crewDict[crewArray[0]["job"].stringValue] = crewArray[0]["name"].stringValue
                    } 
                    print("number of cast inside get cast for movie id: \(castData.count)")
                    completion(castData,crewDict)
                }catch{
                    debugPrint(error)
                }
                
            }else{
                debugPrint(response.result.error as Any)
            }
        }
    }
    
}
