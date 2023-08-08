//
//  RandomBeerViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class RandomBeerViewController: UIViewController {
    
    @IBOutlet var beerImageView: UIImageView!
    @IBOutlet var beerNameLabel: UILabel!
    @IBOutlet var beerDescriptionLabel: UILabel!
    
    @IBOutlet var recommendLabel: UILabel!
    
    @IBOutlet var randomBearButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendLabel.text = "오늘은 이 맥주를 추천합니다!"
        recommendLabel.font = .boldSystemFont(ofSize: 15)
        recommendLabel.textAlignment = .center
        randomBearButton.tintColor = .systemYellow
        randomBearButton.setTitle("다른 맥주 추천받기", for: .normal)
        
        
        randomBeerRequest()
            }
    
    
    func randomBeerRequest() {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let name = json[0]["name"].stringValue
                let image = json[0]["image_url"].stringValue
                let description = json[0]["description"].stringValue
                
                
                print(name)
                print(image)
                print(description)
                print("3")
                
                self.beerNameLabel.text = name
                self.beerDescriptionLabel.text = description
                self.beerDescriptionLabel.numberOfLines = 0
                
                if image == "" {
                    self.randomBeerRequest()
                } else {
                    self.beerImageView.kf.setImage(with: URL(string: image))
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        randomBeerRequest()

        
    }
}
