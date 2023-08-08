//
//  BeerListTableViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/09.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

class BeerListTableViewController: UITableViewController {
    
    var beerName: [String] = []
    var beerImageURL: [String] = []
    var beerDescription: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundleID = "Assignment"
        let bundle = Bundle.init(identifier: bundleID)
        

        let nib = UINib(nibName: "BeerListTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "BeerListTableViewCell")
        callRequest()
//        tableView.rowHeight = 300
        
    }
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
              
                for item in json.arrayValue {
                    self.beerName.append("\(item["name"].stringValue)")
                    self.beerImageURL.append("\(item["image_url"].stringValue)")
                    self.beerDescription.append("\(item["description"].stringValue)")
                    
                }
                print(self.beerName.count)
                print(self.beerDescription.count)
                print(self.beerImageURL.count)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListTableViewCell") as! BeerListTableViewCell
        
       
      
            cell.beerNameLabel.text = beerName[indexPath.row]
            cell.beerDescriptionLabel.text = beerDescription[indexPath.row]
            cell.beerListImageView.kf.setImage(with: URL(string: beerImageURL[indexPath.row]))
        
        
        return cell
    }
}
