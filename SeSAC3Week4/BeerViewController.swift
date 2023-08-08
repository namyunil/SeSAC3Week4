//
//  BeerViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/09.
//

import UIKit

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

class BeerViewController: UIViewController {
   
    

    
    

    
    @IBOutlet var beerTableView: UITableView!
    var beerName: [String] = []
    var beerImageURL: [String] = []
    var beerDescription: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        beerTableView.dataSource = self
        beerTableView.delegate = self
        
        //데이터는 제대로 출력되는데, 테이블 셀이 표현되지 않아 등록시 bundle이 nil로 되어있다면 Main에서 등록된다는 것이라 하여 bundle 문제로 생각해 Main에 구현해봤지만 별 차이가 없었다..!
        //결국 데이터와 화면은 따로 존재하기에 이를 반영해주는 작업을 알맞은 시점에 행해야한다..!
        //생각하는 시간을 갖자..!
        let nib = UINib(nibName: "BeerListTableViewCell", bundle: nil)
        beerTableView.register(nib, forCellReuseIdentifier: "BeerListTableViewCell")
        
        callRequest()
        
        
        
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
                
                //갱신 코드가 없어서 데이터가 반영이 되지 않았던 것..!!
                //갱신 시점에 대해서 항상 생각해보자..!!
                self.beerTableView.reloadData()
                
                print(self.beerName.count)
                print(self.beerDescription.count)
                print(self.beerImageURL.count)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}

extension BeerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerName.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListTableViewCell") as! BeerListTableViewCell
        
        
        
        cell.beerNameLabel.text = beerName[indexPath.row]
        cell.beerNameLabel.textAlignment = .center
        
        cell.beerDescriptionLabel.text = beerDescription[indexPath.row]
        cell.beerDescriptionLabel.numberOfLines = 0
        cell.beerDescriptionLabel.textAlignment = .center
        
        cell.beerListImageView.kf.setImage(with: URL(string: beerImageURL[indexPath.row]))
        
        
        return cell
    }
    
}
