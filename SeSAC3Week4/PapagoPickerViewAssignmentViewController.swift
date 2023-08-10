//
//  PapagoPickerViewAssignmentViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON




class PapagoPickerViewAssignmentViewController: UIViewController {
    
    
    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var targetTextView: UITextView!
    @IBOutlet var translateButton: UIButton!
    
    @IBOutlet var choiceTextField: UITextField!
    @IBOutlet var originalLangCodeTextView: UITextField!
    @IBOutlet var targetLangCodeTextView: UITextField!
    
    let pickerView = UIPickerView()
    
    var langCode: [String] = ["ko", "en", "zh-CN", "zh-TW", "vi", "id", "th", "de", "ru", "es", "it", "fr"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        originalLangCodeTextView.placeholder = "번역 할 언어를 골라주세요"
        
       
        targetLangCodeTextView.placeholder = "번역 결과 언어"
        
        targetTextView.isEditable = false
        
        choiceTextField.inputView = pickerView
        choiceTextField.placeholder = "번역 언어 선택"
        
        originalTextView.text = ""
        originalTextView.backgroundColor = .lightGray
        
        
        targetTextView.text = ""
        targetTextView.backgroundColor = .lightGray
        targetTextView.isEditable = false
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    @IBAction func tranlateButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverID,
            "X-Naver-Client-Secret": APIKey.naverKey
            ]
        let parameters: Parameters = [
            "source": originalLangCodeTextView.text ?? "ko",
            "target": targetLangCodeTextView.text ?? "en",
            "text": originalTextView.text ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let translateText = json["message"]["result"]["translatedText"].stringValue
                print(translateText)
                self.targetTextView.text = translateText
                
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}

extension PapagoPickerViewAssignmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return langCode.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(langCode[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            originalLangCodeTextView.text = langCode[row]
            print(originalLangCodeTextView.text)
        } else if component == 1 {
            targetLangCodeTextView.text = langCode[row]
            print(targetLangCodeTextView.text)
        } else { return }
    }
}
