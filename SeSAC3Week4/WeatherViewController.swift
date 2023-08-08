//
//  WeatherViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire

class WeatherViewController: UIViewController {

    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        callRequest()
    
        
            
        
    }
    
    
    func callRequest() {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=\(APIKey.weatherKey)"
       
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let gust = json["wind"]["gust"].doubleValue
                
                let temp = json["main"]["temp"].doubleValue - 273.15
                let humidity = json["main"]["humidity"].intValue
                
                let id = json["weather"][0]["id"].intValue //803
                
                switch id {
                case 800: print("매우 맑음")
                case 801...899:
                    self.weatherLabel.text = "구름이 낀 날씨입니다"
                    self.view.backgroundColor = .blue
                default: print("나머지는 생략...!!!")
                }
                
                self.tempLabel.text = "\(temp)도 입니다"
                self.humidityLabel.text = "\(humidity)% 입니다"
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
