//
//  LanguageSelectorVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/25/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class LanguageSelectorVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var languageSearchTextField: UITextField!
    var filteredLanguageArray = [[String]]()
    
    var languageArray = [[String]]()
    var selectedLanguage : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.languageSearchTextField.delegate = self
        self.languageSearchTextField.addTarget(self, action: #selector(LanguageSelectorVC.textFieldDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
        DataService.instance.getLanguageCodes { (data) in
            var data = data
            data.removeFirst()
            self.languageArray = data
            self.filteredLanguageArray = data
            self.tableView.reloadData()
        }
    }
    
    @objc func textFieldDidChange(){
        if self.languageSearchTextField.text != ""{
            self.filteredLanguageArray = self.languageArray.filter({
                $0[0].lowercased().contains(self.languageSearchTextField.text!)
            })
            tableView.reloadData()
        }else{
            self.filteredLanguageArray = self.languageArray
            tableView.reloadData()
        }
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        if selectedLanguage != nil{
        let nav = self.presentingViewController as! UINavigationController
        let presentingVC = nav.viewControllers.first as! ViewController
        for language in self.filteredLanguageArray{
            if self.selectedLanguage != nil{
                if language[0] == self.selectedLanguage{
                    DataService.instance.setSelectedLanguage(language: language[1])
                    }
            }
        presentingVC.selectedLanguage.text = self.selectedLanguage
        dismiss(animated: true, completion: nil)
        
    }
        }
}
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension LanguageSelectorVC : UITextFieldDelegate {
    
}

extension LanguageSelectorVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredLanguageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as? LanguageCell else { return UITableViewCell()}
        if selectedLanguage != nil {
        if self.filteredLanguageArray[indexPath.row][0] == selectedLanguage{
            cell.tickImage.isHidden = false
        }else {
            cell.tickImage.isHidden = true
        }
        } else {
            cell.tickImage.isHidden = true
        }
        cell.languageLabel.text = self.filteredLanguageArray[indexPath.row][0]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? LanguageCell
        if selectedLanguage != nil{
        if (cell?.languageLabel.text)! == selectedLanguage{
            selectedLanguage = nil
        } else{
            selectedLanguage = (cell?.languageLabel.text)!
        }
        }else{
            selectedLanguage = (cell?.languageLabel.text)!
        }
    
        self.tableView.reloadData()
    }
}
