//
//  PapagoAssignmentViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/10.
//

import UIKit
import SwiftyJSON
import Alamofire


class PapagoAssignmentViewController: UIViewController {

    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var targetTextView: UITextView!
    
    @IBOutlet var translateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        originalTextView.text = ""
        targetTextView.text = ""
        targetTextView.isEditable = false
        
    }
    
    
    @IBAction func translateButtonClicked(_ sender: UIButton) {
        
        view.endEditing(true)
        
        
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverID,
            "X-Naver-Client-Secret": APIKey.naverKey
            ]
        let parameter: Parameters = [
            "query": self.originalTextView.text ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let langCode = json["langCode"]
               
                let url = "https://openapi.naver.com/v1/papago/n2mt"
                let header: HTTPHeaders = [
                    "X-Naver-Client-Id": APIKey.naverID,
                    "X-Naver-Client-Secret": APIKey.naverKey
                    ]
                let parameters: Parameters = [
                    "source": "\(langCode)",
                    "target": "en",
                    "text": self.originalTextView.text ?? ""
                ]
                
                AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("JSON: \(json)")
                        
                        let data = json["message"]["result"]["translatedText"].stringValue
                        
                        
                        self.targetTextView.text = data
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    

}
