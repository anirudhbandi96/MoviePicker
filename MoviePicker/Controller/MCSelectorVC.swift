//
//  MCSelectorVC.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/25/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class MCSelectorVC: UIViewController {

    @IBOutlet weak var mcSearchTextField: UITextField!
    var selectedCertificate : [String]!
    @IBOutlet weak var tableView: UITableView!
    var certificateData = [CountryCertificate]()
    var filteredCertificateData = [CountryCertificate]()
    var countryCodeToNameDict = [String:String]()
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        mcSearchTextField.delegate = self
        mcSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
        DataService.instance.getCertificateData { (data) in
            self.certificateData = data
            self.filteredCertificateData = data
        }
        DataService.instance.getCountryCodeToNameConversionDict { (dict) in
            self.countryCodeToNameDict = dict
            self.tableView.reloadData()
        }
    }
    @objc func textFieldDidChange(){
        if mcSearchTextField.text != ""{
            self.filteredCertificateData = certificateData.filter({x in
                
               if let text = mcSearchTextField.text {
                if let country =  self.countryCodeToNameDict[x.country] {
                    if country.lowercased().contains(text.lowercased()) {
                        return true
                    }else{
                        return false
                    }
                }else {
                     return false
                }
               }else {
                return false
                }
                
            })
        }else{
            self.filteredCertificateData = certificateData
        }
        tableView.reloadData()
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        if selectedCertificate != nil {
        let nav = self.presentingViewController as! UINavigationController
        let presentingVC = nav.viewControllers.first as! ViewController
        presentingVC.selectedCertificate.text = self.countryCodeToNameDict[self.selectedCertificate[0]]!+","+self.selectedCertificate[1]
        DataService.instance.setSelectedCertificate(certificate: self.selectedCertificate)
        dismiss(animated: true, completion: nil)
    }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MCSelectorVC: UITextFieldDelegate {
    
}

extension MCSelectorVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCertificateData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCertificateData[section].certificates.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.countryCodeToNameDict[filteredCertificateData[section].country]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "certificateCell", for: indexPath) as? CertificateCell else { return UITableViewCell() }
        cell.certificateName.text = self.filteredCertificateData[indexPath.section].certificates[indexPath.row].name
        cell.certificateDescription.text = self.filteredCertificateData[indexPath.section].certificates[indexPath.row].meaning
        cell.certificateDescription.sizeToFit()
        if self.selectedCertificate != nil{
            if  self.selectedCertificate[0] == self.filteredCertificateData[indexPath.section].country && self.selectedCertificate[1] == self.filteredCertificateData[indexPath.section].certificates[indexPath.row].name{
                
                cell.tickImage.isHidden = false
            }else{
                cell.tickImage.isHidden = true
            }
        }else{
            cell.tickImage.isHidden = true
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedCertificate != nil {
            if self.selectedCertificate == [self.filteredCertificateData[indexPath.section].country,self.filteredCertificateData[indexPath.section].certificates[indexPath.row].name] {
                self.selectedCertificate = nil
            } else {
                self.selectedCertificate = [self.filteredCertificateData[indexPath.section].country,self.filteredCertificateData[indexPath.section].certificates[indexPath.row].name]
            }
        }else{
        self.selectedCertificate = [self.filteredCertificateData[indexPath.section].country,self.filteredCertificateData[indexPath.section].certificates[indexPath.row].name]
        }
        tableView.reloadData()
    }
    
}
