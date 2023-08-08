//
//  LottreryViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class LottreryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet var lotteryTextField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bonusLabel: UILabel!
    @IBOutlet var lottoNumberLabel: UILabel!
    
    var pickerView = UIPickerView()
    
    var list: [Int] = Array(1...1079).reversed()
    var lottoNumber: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        lotteryTextField.inputView = pickerView
        lotteryTextField.text = "1079"
        
        callRequest(number: 1079)
    }
    

    func callRequest(number: Int) {
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let date = json["drwNoDate"].stringValue
                let bonusNumber = json["bnusNo"].intValue
                
                let drawNumber1 = json["drwtNo1"].intValue
                let drawNumber2 = json["drwtNo2"].intValue
                let drawNumber3 = json["drwtNo3"].intValue
                let drawNumber4 = json["drwtNo4"].intValue
                let drawNumber5 = json["drwtNo5"].intValue
                let drawNumber6 = json["drwtNo7"].intValue
                
                print(date, bonusNumber)
                self.dateLabel.text = date
                self.bonusLabel.text = "\(bonusNumber)"
                self.lottoNumberLabel.text = "\(drawNumber1),\(drawNumber2),\(drawNumber3),\(drawNumber4),\(drawNumber5),\(drawNumber6),\(bonusNumber)"

            case .failure(let error):
                print(error)
            }
        }
    }
    //PickerView의 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //PickerView 행의 수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select \(row)")
        
        lotteryTextField.text = "\(list[row])"
        callRequest(number: list[row])
    }
    
    //PickerView 행에 들어갈 이름들
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(list[row])"
    }
    
    
    
}
