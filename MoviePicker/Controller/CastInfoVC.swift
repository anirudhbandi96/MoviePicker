//
//  castInfoVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 3/7/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit
import WebKit

class CastInfoVC: UIViewController {

    var actorName: String!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if actorName != nil {
            let actorName = String(Array(self.actorName).map({$0 == " " ? "_" : $0 }))
            let urlString = "https://en.wikipedia.org/wiki/\(actorName)"
            let url = URL(string: urlString)
            let urlRequest = URLRequest(url: url!)
            self.webView.load(urlRequest)
    }
        
    }

}
